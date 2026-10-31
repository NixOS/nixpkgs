{
  bison,
  cacert,
  fetchFromGitHub,
  flex,
  php,
  lib,
  stdenv,
  installShellFiles,
  which,
  python3,
}:

# Make a custom wrapper. If `wrapProgram` is used, arcanist thinks .arc-wrapped is being
# invoked and complains about it being an unknown toolset. We could use `makeWrapper`, but
# then we’d need to still craft a script that does the `php libexec/arcanist/bin/...` dance
# anyway... So just do everything at once.
let
  makeArcWrapper = toolset: ''
    cat << WRAPPER > $out/bin/${toolset}
    #!$shell -e
    export PATH='${php}/bin:${which}/bin'\''${PATH:+':'}\$PATH
    exec ${php}/bin/php $out/libexec/arcanist/bin/${toolset} "\$@"
    WRAPPER
    chmod +x $out/bin/${toolset}
  '';

in
stdenv.mkDerivation {
  pname = "arcanist";
  version = "0-unstable-2026-07-19";

  # The phorgeit fork is the maintained continuation of the upstream
  # (archived) phacility/arcanist.
  src = fetchFromGitHub {
    owner = "phorgeit";
    repo = "arcanist";
    rev = "b084cd508f587aaa2ed6fef5e2cee163b4bdd259";
    hash = "sha256-8QxRCYF4gnuuOBO2lZm9bbfj0ApeqUobPy/MXfhH8zE=";
  };

  patches = [
    ./dont-require-python3-in-path.patch
  ];

  strictDeps = true;
  __structuredAttrs = true;

  # python3 stays in buildInputs so patchShebangs resolves the
  # arcanoid.py shebang; php also runs at build time (xhpast codegen).
  buildInputs = [ python3 ];

  nativeBuildInputs = [
    bison
    flex
    installShellFiles
    php
  ];

  postPatch = lib.optionalString stdenv.hostPlatform.isAarch64 ''
    substituteInPlace support/xhpast/Makefile \
      --replace "-minline-all-stringops" ""
  '';

  buildPhase = ''
    runHook preBuild
    make cleanall -C support/xhpast $makeFlags "''${makeFlagsArray[@]}" -j $NIX_BUILD_CORES
    make xhpast   -C support/xhpast $makeFlags "''${makeFlagsArray[@]}" -j $NIX_BUILD_CORES
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin $out/libexec
    make install  -C support/xhpast $makeFlags "''${makeFlagsArray[@]}" -j $NIX_BUILD_CORES
    make cleanall -C support/xhpast $makeFlags "''${makeFlagsArray[@]}" -j $NIX_BUILD_CORES
    cp -R . $out/libexec/arcanist
    ln -sf ${cacert}/etc/ssl/certs/ca-bundle.crt $out/libexec/arcanist/resources/ssl/default.pem

    ${makeArcWrapper "arc"}
    ${makeArcWrapper "phage"}

    $out/bin/arc shell-complete --generate --
    installShellCompletion --cmd arc --bash $out/libexec/arcanist/support/shell/rules/bash-rules.sh
    installShellCompletion --cmd phage --bash $out/libexec/arcanist/support/shell/rules/bash-rules.sh
    runHook postInstall
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    $out/bin/arc help diff -- > /dev/null
    $out/bin/phage help alias -- > /dev/null
  '';

  meta = {
    description = "Command line interface to Phorge and Phabricator";
    homepage = "https://we.phorge.it/";
    license = lib.licenses.asl20;
    platforms = lib.platforms.unix;
    mainProgram = "arc";
  };
}

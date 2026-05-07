# When updating this package please check that all other versions of Nim
# evaluate because they reuse definitions from the latest compiler.
{
  lib,
  stdenv,
  fetchurl,
  boehmgc,
  openssl,
  pcre,
  readline,
  sqlite,
  darwin,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "nim-unwrapped";
  version = "2.2.4";
  strictDeps = true;

  src = fetchurl {
    url = "https://nim-lang.org/download/nim-${finalAttrs.version}.tar.xz";
    hash = "sha256-+CtBl1D8zlYfP4l6BIaxgBhoRddvtdmfJIzhZhCBicc=";
  };

  buildInputs = [
    boehmgc
    openssl
    pcre
    readline
    sqlite
  ];

  patches = [
    ./NIM_CONFIG_DIR.patch
    # Override compiler configuration via an environmental variable

    ./nixbuild.patch
    # Load libraries at runtime by absolute path

    ./extra-mangling-2.patch
    # Mangle store paths of modules to prevent runtime dependence.

    ./openssl.patch
    # dlopen is widely used by Python, Ruby, Perl, ... what you're really telling me here is that your OS is fundamentally broken. That might be news for you, but it isn't for me.
  ];

  configurePhase =
    let
      bootstrapCompiler = stdenv.mkDerivation {
        pname = "nim-bootstrap";
        inherit (finalAttrs) version src preBuild;
        enableParallelBuilding = true;
        installPhase = ''
          runHook preInstall
          install -Dt $out/bin bin/nim
          runHook postInstall
        '';
      };
    in
    ''
      runHook preConfigure
      cp ${bootstrapCompiler}/bin/nim bin/
      echo 'define:nixbuild' >> config/nim.cfg
      runHook postConfigure
    '';

  kochArgs = [
    "--cpu:${stdenv.hostPlatform.nim.cpu}"
    "--os:${stdenv.hostPlatform.nim.os}"
    "-d:release"
    "-d:useGnuReadline"
  ]
  ++ lib.optional (stdenv.hostPlatform.isDarwin || stdenv.hostPlatform.isLinux) "-d:nativeStacktrace";

  preBuild = lib.optionalString (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64) ''
    substituteInPlace makefile \
      --replace "aarch64" "arm64"
  '';

  buildPhase = ''
    runHook preBuild
    local HOME=$TMPDIR
    ./bin/nim c --parallelBuild:$NIX_BUILD_CORES koch
    ./koch boot $kochArgs --parallelBuild:$NIX_BUILD_CORES
    ./koch toolsNoExternal $kochArgs --parallelBuild:$NIX_BUILD_CORES
    ./bin/nim js -d:release tools/dochack/dochack.nim
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    install -Dt $out/bin bin/*
    ln -sf $out/nim/bin/nim $out/bin/nim
    ln -sf $out/nim/lib $out/lib
    ./install.sh $out
    cp -a tools dist $out/nim/
    runHook postInstall
  '';

  passthru = {
    nimHost = lib.warn "nimHost is deprecated, please use stdenv.hostPlatform.nim.os instead." stdenv.hostPlatform.nim.os;
    nimTarget = lib.warn "nimTarget is deprecated, please use stdenv.hostPlatform.nim.cpu instead." stdenv.hostPlatform.cpu;
  };

  meta = {
    description = "Statically typed, imperative programming language";
    homepage = "https://nim-lang.org/";
    license = lib.licenses.mit;
    mainProgram = "nim";
    teams = [ lib.teams.nim ];
  };

})

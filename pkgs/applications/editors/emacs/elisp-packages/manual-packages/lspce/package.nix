{
  lib,
  f,
  markdown-mode,
  melpaBuild,
  nix-update-script,
  yasnippet,
  fetchFromGitHub,
  rustPlatform,
}:

let
  src = fetchFromGitHub {
    owner = "zbelial";
    repo = "lspce";
    rev = "fd320476df89cfd5d10f1b70303c891d3b1e3c81";
    hash = "sha256-KnERYq/CvJhJIdQkpH/m82t9KFMapPl+CyZkYyujslU=";
  };
in
melpaBuild {
  pname = "lspce";
  version = "1.1.0-unstable-2024-07-14";

  inherit src;

  packageRequires = [
    f
    markdown-mode
    yasnippet
  ];

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    hash = "sha256-BMbkdWsVSXRNt8kqOs05376cGnGnivHGvEugX0p3bVc=";
  };

  nativeBuildInputs = [
    rustPlatform.cargoSetupHook
    rustPlatform.cargoBuildHook
    rustPlatform.cargoInstallHook
    rustPlatform.cargoCheckHook
  ];

  cargoBuildType = "release";

  # Copy the default buildPhase here and switch cd to pushd/popd in
  # order to not cause rebuild of other Emacs lisp packages.
  buildPhase = ''
    runHook preBuild

    pushd "$NIX_BUILD_TOP"

    emacs --batch -Q \
        -L "$NIX_BUILD_TOP/package-build" \
        -l "$melpa2nix" \
        -f melpa2nix-build-package \
        $ename $melpaVersion $commit

    popd

    runHook postBuild
  '';

  # Copy the default installPhase here because adding the dynamic
  # module to the package tarball needs to be done at a specific time,
  # i.e., between cargoInstallHook and elpa2nix-install-package.
  # It cannot be done in preInstall because preInstall, as an implicit
  # string hook, runs before cargoInstallHook, as a hook in
  # preInstallHooks.
  installPhase = ''
    runHook preInstall

    archive="$NIX_BUILD_TOP/packages/$ename-$melpaVersion.el"
    if [ ! -f "$archive" ]; then
        archive="$NIX_BUILD_TOP/packages/$ename-$melpaVersion.tar"
    fi

    echo "add the dynamic module to the package tarball because it is needed for compilation"
    # rename module without changing suffix
    # use for loop because there seem to be two modules on darwin systems
    # https://github.com/zbelial/lspce/issues/7#issue-1783708570
    tmp_content_directory=$ename-$melpaVersion
    mkdir $tmp_content_directory
    for f in $out/lib/*; do
      mv --verbose $f $tmp_content_directory/lspce-module.''${f##*.}
      tar --verbose --append --file=$archive $tmp_content_directory/lspce-module.''${f##*.}
    done
    rmdir --verbose $out/lib
    unset tmp_content_directory

    emacs --batch -Q \
        -l "$elpa2nix" \
        -f elpa2nix-install-package \
        "$archive" "$out/share/emacs/site-lisp/elpa"

    runHook postInstall
  '';

  doCheck = true;
  cargoCheckType = "release";
  checkFlags = [
    # flaky test
    "--skip=msg::tests::serialize_request_with_null_params"
  ];

  passthru = {
    updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };
  };

  meta = {
    homepage = "https://github.com/zbelial/lspce";
    description = "LSP Client for Emacs implemented as a module using Rust";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ AndersonTorres ];
  };
}

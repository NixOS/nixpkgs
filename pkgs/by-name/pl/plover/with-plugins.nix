{
  lib,
  stdenvNoCC,
  makeWrapper,
  python3,
  # For testing
  versionCheckHook,
}:

selectPackages:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "plover-wrapper-with-plugins";
  inherit (python3.pkgs.plover) version;
  nativeBuildInputs = [
    makeWrapper
  ];
  dontUnpack = true;
  installPhase = ''
    runHook preInstall
    mkdir -p "''${!outputBin}/bin"
    for _pathFromPlover in ${lib.getBin python3.pkgs.plover}/bin/*; do
      _nameFromPlover=$(basename "$_pathFromPlover")
      makeWrapper "${lib.getBin finalAttrs.passthru.python-env}/bin/$_nameFromPlover" "''${!outputBin}/bin/$_nameFromPlover"
    done
    runHook postInstall
  '';
  doInstallCheck = true;
  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  passthru = {
    python-env = python3.withPackages (packages: [ packages.plover ] ++ selectPackages packages);
  };
  meta = {
    mainProgram = "plover";
  };
})

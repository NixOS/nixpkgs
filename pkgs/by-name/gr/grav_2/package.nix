{
  stdenvNoCC,
  lib,
  fetchzip,
  nixosTests,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "grav";
  version = "2.0.24";

  __structuredAttrs = true;
  strictDeps = true;

  src =
    let
      v = finalAttrs.version;
    in
    fetchzip {
      url = "https://github.com/getgrav/grav/releases/download/${v}/grav-admin-v${v}.zip";
      hash = "sha256-Plow++quy9/77wVr/Thz6QcFAn+rIJercbUdhKDe0Qs=";
    };

  patches = [
    # Disables functionality that attempts to edit files in Nix store. Also adds
    # a block of the self-upgrade command.
    ./01-nix.patch
  ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/
    cp -R . $out/
    runHook postInstall
  '';

  passthru.tests = {
    grav = nixosTests.grav;
  };

  meta = {
    description = "Fast, simple, and flexible, file-based web platform";
    homepage = "https://getgrav.com";
    maintainers = with lib.maintainers; [ rycee ];
    license = lib.licenses.mit;
  };
})

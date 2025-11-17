{
  stdenvNoCC,
  lib,
  fetchzip,
  nixosTests,
}:

let
  version = "1.7.50.3";
in
stdenvNoCC.mkDerivation {
  pname = "grav";
  inherit version;

  src = fetchzip {
    url = "https://github.com/getgrav/grav/releases/download/${version}/grav-admin-v${version}.zip";
    hash = "sha256-W4JuW5NEko38AbLrLOGWYsRvehPV7+tX2Hq1tTZ22EY=";
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

  meta = with lib; {
    description = "Fast, simple, and flexible, file-based web platform";
    homepage = "https://getgrav.com";
    maintainers = with maintainers; [ rycee ];
    license = licenses.mit;
  };
}

{
  lib,
  stdenv,
  fetchFromGitHub,
  wayland-scanner,
  nix-update-script,
  nixosTests,
}:

stdenv.mkDerivation {
  pname = "cosmic-protocols";
  version = "0-unstable-2026-05-08";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-protocols";
    rev = "c253ec1d6804afbcdf250f5cc37ae1194bba7bd2";
    hash = "sha256-KO7VTxomhrnwzFlkkXSoP0eh3NRShBD4srW5W6temxo=";
  };

  __structuredAttrs = true;
  strictDeps = true;

  makeFlags = [ "PREFIX=${placeholder "out"}" ];
  nativeBuildInputs = [ wayland-scanner ];

  passthru = {
    tests = {
      inherit (nixosTests)
        cosmic
        cosmic-autologin
        cosmic-noxwayland
        cosmic-autologin-noxwayland
        ;
    };
    updateScript = nix-update-script {
      extraArgs = [
        "--version"
        "branch=HEAD"
      ];
    };
  };

  meta = {
    homepage = "https://github.com/pop-os/cosmic-protocols";
    description = "Additional wayland-protocols used by the COSMIC desktop environment";
    license = with lib.licenses; [
      mit
      gpl3Only
    ];
    teams = [ lib.teams.cosmic ];
    platforms = lib.platforms.linux;
  };
}

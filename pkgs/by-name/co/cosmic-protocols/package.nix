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
  version = "0-unstable-2025-06-19";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-protocols";
    rev = "408af98de5122577a0df80a64b85c7e1c5c7b6e0";
    hash = "sha256-yfCtv0HfxlyCABCVTRUiutHxfPEu0Anp+cdkdVwyyRY=";
  };

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

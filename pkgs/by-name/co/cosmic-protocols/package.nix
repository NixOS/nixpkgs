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
  version = "0-unstable-2025-08-04";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-protocols";
    rev = "5035f8c810bf734401e21e0a9625c7b7e0c73325";
    hash = "sha256-FYfSVg7v7S8G1gHZ5puAqb2yZES81HK+KMu0819cQ8w=";
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

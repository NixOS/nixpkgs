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
  version = "0-unstable-2026-08-14";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-protocols";
    rev = "a2da48188362c4ea05d33de2f6c67d8148deba88";
    hash = "sha256-hqsOzu0mlkE2jtgL5HvbT9vtOKiMSniNwV+xk4UzTkc=";
  };

  __structuredAttrs = true;
  strictDeps = true;

  nativeBuildInputs = [ wayland-scanner ];

  makeFlags = [ "PREFIX=${placeholder "out"}" ];

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

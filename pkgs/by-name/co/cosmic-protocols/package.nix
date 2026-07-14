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
  version = "0-unstable-2026-07-10";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-protocols";
    rev = "e95d89504513e1407f89a189aca328fbecc9eeef";
    hash = "sha256-u1Ur9lPm2HE60jCEJVhKtbGYfzV8pdiDjrsGwgKf3nA=";
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

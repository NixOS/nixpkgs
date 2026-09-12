{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  nixosTests,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cosmic-sound-theme";
  version = "1.7.0";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-sound-theme";
    tag = "epoch-${finalAttrs.version}";
    sha256 = "sha256-hFWTn73SutdOZGbhkcsBR1TNabB+IOrxRndwXaikqN8=";
  };

  strictDeps = true;
  __structuredAttrs = true;
  separateDebugInfo = true;

  nativeBuildInputs = [
    meson
    ninja
  ];

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
        "--version-regex"
        "epoch-(.*)"
      ];
    };
  };

  meta = {
    description = "System76 COSMIC Sound Theme";
    homepage = "https://github.com/pop-os/cosmic-sound-theme";
    license = lib.licenses.cc-by-sa-40;
    teams = [ lib.teams.cosmic ];
    platforms = lib.platforms.linux;
  };
})

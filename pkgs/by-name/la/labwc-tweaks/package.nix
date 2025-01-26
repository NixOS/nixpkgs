{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  perl,
  pkg-config,
  qt6,
  xkeyboard_config,
  unstableGitUpdater,
}:

stdenv.mkDerivation {
  pname = "labwc-tweaks";
  version = "0-unstable-2024-04-27";

  src = fetchFromGitHub {
    owner = "labwc";
    repo = "labwc-tweaks";
    rev = "9007079640e0f38c1d69ac94899229354a5c67b2";
    hash = "sha256-klKPHAhJ6fedFojXPfesjs1dG5NJhBZkzynhka5vD8M=";
  };

  nativeBuildInputs = [
    cmake
    perl
    pkg-config
    qt6.qttools
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtwayland
  ];

  strictDeps = true;

  postPatch = ''
    substituteInPlace tweaks-qt/gen-layout-list --replace-fail /usr/share/X11/xkb ${xkeyboard_config}/share/X11/xkb
  '';

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    homepage = "https://github.com/labwc/labwc-tweaks";
    description = "Configuration gui app for labwc";
    mainProgram = "labwc-tweaks";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [
      AndersonTorres
      romildo
    ];
  };
}

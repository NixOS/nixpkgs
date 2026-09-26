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

stdenv.mkDerivation (finalAttrs: {
  pname = "labwc-tweaks";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "labwc";
    repo = "labwc-tweaks";
    tag = finalAttrs.version;
    hash = "sha256-himbdQ3cu+9NnbO5mYOKh30WIp55lSIkwvHAC89IzC8=";
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
    substituteInPlace bin/gen-layout-list --replace-fail /usr/share/X11/xkb ${xkeyboard_config}/share/X11/xkb
  '';

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    homepage = "https://github.com/labwc/labwc-tweaks";
    description = "Configuration gui app for labwc";
    mainProgram = "labwc-tweaks";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [
      romildo
    ];
  };
})

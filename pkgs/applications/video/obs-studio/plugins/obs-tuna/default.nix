{
  lib,
  stdenv,
  fetchFromGitHub,
  obs-studio,
  cmake,
  zlib,
  curl,
  dbus,
  pkg-config,
  qtbase,
  wrapQtAppsHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "obs-tuna";
  version = "1.9.10";

  nativeBuildInputs = [
    cmake
    pkg-config
    wrapQtAppsHook
  ];
  buildInputs = [
    obs-studio
    qtbase
    zlib
    curl
    dbus
  ];

  src = fetchFromGitHub {
    owner = "univrsal";
    repo = "tuna";
    rev = "v${finalAttrs.version}";
    hash = "sha256-Y4ny8XJIk4KtmRTWdO6tHevT4Ivr1TqkNMNhua499sY=";
    fetchSubmodules = true;
  };

  dontWrapQtApps = true;

  meta = {
    description = "Song information plugin for obs-studio";
    homepage = "https://github.com/univrsal/tuna";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ shortcord ];
    platforms = lib.platforms.linux;
  };
})

{
  lib,
  stdenv,
  fetchFromGitHub,
  obs-studio,
  cmake,
  zlib,
  curl,
  taglib,
  dbus,
  pkg-config,
  qtbase,
  wrapQtAppsHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "obs-tuna";
  version = "1.9.9";

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
    taglib
    dbus
  ];

  src = fetchFromGitHub {
    owner = "univrsal";
    repo = "tuna";
    rev = "v${finalAttrs.version}";
    hash = "sha256-qwOAidnCGZSwTahgbyf1K0KgoDvYpqDAQXM3l1lfZXg=";
    fetchSubmodules = true;
  };

  dontWrapQtApps = true;

  meta = with lib; {
    description = "Song information plugin for obs-studio";
    homepage = "https://github.com/univrsal/tuna";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ shortcord ];
    platforms = platforms.linux;
  };
})

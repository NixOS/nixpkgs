{ lib
, stdenv
, fetchFromGitHub
, obs-studio
, cmake
, zlib
, curl
, taglib
, dbus
, pkg-config
, qtbase
, wrapQtAppsHook
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "obs-tuna";
  version = "1.9.6";

  nativeBuildInputs = [ cmake pkg-config wrapQtAppsHook ];
  buildInputs = [ obs-studio qtbase zlib curl taglib dbus ];

  src = fetchFromGitHub {
    owner = "univrsal";
    repo = "tuna";
    rev = "v${finalAttrs.version}";
    hash = "sha256-+AgRaivvYhogX4CLGK2ylvE8tQoauC/UMvXK6W0Tvog=";
    fetchSubmodules = true;
  };

  postInstall = ''
    mkdir $out/lib $out/share
    mv $out/obs-plugins/64bit $out/lib/obs-plugins
    rm -rf $out/obs-plugins
    mv $out/data $out/share/obs
  '';

  dontWrapQtApps = true;

  meta = {
    description = "Song information plugin for obs-studio";
    homepage = "https://github.com/univrsal/tuna";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ shortcord ];
    platforms = lib.platforms.linux;
  };
})

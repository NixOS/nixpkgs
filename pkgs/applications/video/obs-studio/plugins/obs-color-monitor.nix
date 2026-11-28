{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  obs-studio,
  qt6,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "obs-color-monitor";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "norihiro";
    repo = "obs-color-monitor";
    tag = finalAttrs.version;
    fetchSubmodules = true;
    hash = "sha256-QXhFYZLo5TFReI6xsOwB0Ty+Jf9KaefWcCnjMiHJyno=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    obs-studio
    qt6.qtbase
  ];

  cmakeFlags = [ (lib.cmakeFeature "QT_VERSION" "6") ];

  dontWrapQtApps = true;

  meta = {
    description = "Color Monitor plugin for OBS Studio";
    homepage = "https://github.com/norihiro/obs-color-monitor";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ hlad ];
  };
})

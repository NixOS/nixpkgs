{ lib
, stdenv
, fetchFromGitHub
, asio
, cmake
, curl
, obs-studio
, opencv
, procps
, qtbase
, websocketpp
, xorg
}:

stdenv.mkDerivation rec {
  pname = "advanced-scene-switcher";
  version = "1.21.1";

  src = fetchFromGitHub {
    owner = "WarmUpTill";
    repo = "SceneSwitcher";
    rev = version;
    sha256 = "1p6fl1fy39hrm7yasjhv6z79bnjk2ib3yg9dvf1ahwzkd9bpyfyl";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    asio
    curl
    obs-studio
    opencv
    procps
    qtbase
    websocketpp
    xorg.libXScrnSaver
  ];

  dontWrapQtApps = true;

  postInstall = ''
    mkdir $out/lib $out/share
    mv $out/obs-plugins/64bit $out/lib/obs-plugins
    mv $out/data $out/share/obs
  '';

  meta = {
    description = "An automated scene switcher for OBS Studio";
    homepage = "https://github.com/WarmUpTill/SceneSwitcher";
    maintainers = with lib.maintainers; [ paveloom ];
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
}

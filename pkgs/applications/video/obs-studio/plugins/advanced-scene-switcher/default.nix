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
  version = "1.20.5";

  src = fetchFromGitHub {
    owner = "WarmUpTill";
    repo = "SceneSwitcher";
    rev = version;
    sha256 = "04k7f7v756vdsan95g73cc29lrs61jis738v37a3ihi3ivps3ma3";
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

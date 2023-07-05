{ alsa-lib
, asio
, cmake
, curl
, fetchFromGitHub
, lib
, libremidi
, obs-studio
, opencv
, procps
, qtbase
, stdenv
, websocketpp
, xorg
}:

stdenv.mkDerivation rec {
  pname = "advanced-scene-switcher";
  version = "1.22.1";

  src = fetchFromGitHub {
    owner = "WarmUpTill";
    repo = "SceneSwitcher";
    rev = version;
    hash = "sha256-SV5hnTIRJ6ZruA5t/G6zRAC/+oalTABor3h66eF+KHM=";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    alsa-lib
    asio
    curl
    libremidi
    obs-studio
    opencv
    procps
    qtbase
    websocketpp
    xorg.libXScrnSaver
  ];

  dontWrapQtApps = true;

  postUnpack = ''
    cp -r ${libremidi.src}/* $sourceRoot/deps/libremidi
  '';

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

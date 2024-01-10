{ lib
, fetchFromGitHub

, cmake
, ninja

, alsa-lib
, asio
, curl
, nlohmann_json
, obs-studio
, opencv
, procps
, qtbase
, stdenv
, tesseract
, websocketpp
, xorg

, httplib
, libremidi
}:

stdenv.mkDerivation rec {
  pname = "advanced-scene-switcher";
  version = "1.24.0";

  src = fetchFromGitHub {
    owner = "WarmUpTill";
    repo = "SceneSwitcher";
    rev = version;
    hash = "sha256-Xnf8Vz6I5EfiiVoG0JRd0f0IJHw1IVkTLL4Th/hWYrc=";
  };

  nativeBuildInputs = [
    cmake
    ninja
  ];

  buildInputs = [
    alsa-lib
    asio
    curl
    libremidi
    nlohmann_json
    obs-studio
    opencv
    procps
    qtbase
    tesseract
    websocketpp
    xorg.libXScrnSaver
  ];

  dontWrapQtApps = true;

  postUnpack = ''
    cp -r ${httplib.src}/* $sourceRoot/deps/cpp-httplib
    cp -r ${libremidi.src}/* $sourceRoot/deps/libremidi
    chmod -R +w $sourceRoot/deps/cpp-httplib
    chmod -R +w $sourceRoot/deps/libremidi
  '';

  postInstall = ''
    mkdir $out/lib $out/share
    mv $out/obs-plugins/64bit $out/lib/obs-plugins
    mv $out/data $out/share/obs
  '';

  meta = with lib; {
    description = "An automated scene switcher for OBS Studio";
    homepage = "https://github.com/WarmUpTill/SceneSwitcher";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ paveloom ];
  };
}

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
  version = "1.26.0";

  src = fetchFromGitHub {
    owner = "WarmUpTill";
    repo = "SceneSwitcher";
    rev = version;
    hash = "sha256-ba+QQWekDp/9V+kNcNowXXJrfU4DCttz0tSoC7Ko1bE=";
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

  env.NIX_CFLAGS_COMPILE = "-Wno-error=stringop-overflow";

  meta = with lib; {
    description = "An automated scene switcher for OBS Studio";
    homepage = "https://github.com/WarmUpTill/SceneSwitcher";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ ];
  };
}

{
  lib,
  fetchFromGitHub,

  cmake,
  ninja,

  alsa-lib,
  asio,
  curl,
  libremidi,
  nlohmann_json,
  obs-studio,
  opencv,
  procps,
  qtbase,
  stdenv,
  tesseract,
  websocketpp,
  libXScrnSaver,
}:

let
  httplib-src = fetchFromGitHub {
    owner = "yhirose";
    repo = "cpp-httplib";
    rev = "v0.17.3";
    hash = "sha256-yvaPIbRqJGkiob3Nrv3H1ieFAC5b+h1tTncJWTy4dmk=";
  };
in
stdenv.mkDerivation rec {
  pname = "advanced-scene-switcher";
  version = "1.27.2";

  src = fetchFromGitHub {
    owner = "WarmUpTill";
    repo = "SceneSwitcher";
    rev = version;
    hash = "sha256-7IciHCe2KemKNJpD9QcYK4AtxHlYuWaPsBCcVuPVvgA=";
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
    libXScrnSaver
  ];

  dontWrapQtApps = true;

  postUnpack = ''
    cp -r ${httplib-src}/* $sourceRoot/deps/cpp-httplib
    cp -r ${libremidi.src}/* $sourceRoot/deps/libremidi
    chmod -R +w $sourceRoot/deps/cpp-httplib
    chmod -R +w $sourceRoot/deps/libremidi
  '';

  env.NIX_CFLAGS_COMPILE = "-Wno-error=stringop-overflow";

  meta = with lib; {
    description = "Automated scene switcher for OBS Studio";
    homepage = "https://github.com/WarmUpTill/SceneSwitcher";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = [ ];
  };
}

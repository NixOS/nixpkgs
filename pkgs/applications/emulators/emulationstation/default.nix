{ lib
, stdenv
, fetchFromGitHub
, alsa-lib
, boost
, cmake
, curl
, eigen
, freeimage
, freetype
, libGL
, libGLU
, libarchive
, pkg-config
, pugixml
, rapidjson
, SDL2
, vlc
}:

let

  version = "2.11.2";
in
stdenv.mkDerivation {
  pname = "emulationstation";
  inherit version;

  src = fetchFromGitHub {
    owner = "RetroPie";
    repo = "EmulationStation";
    rev = "v${version}";
    hash = "sha256-f2gRkp+3Pp2qnvg2RBzaHPpzhAnwx0+5x1Pe3kD90xE=";
  };

  patches = [
    # TODO: remove when merged upstream
    # (https://github.com/RetroPie/EmulationStation/pull/821)
   ./fix-pugixml-detection.patch
  ];

  postPatch = ''
     substituteInPlace es-core/src/resources/ResourceManager.cpp \
      --replace 'Utils::FileSystem::getExePath() + "/resources/"' "std::string{\"$out/resources/\"}"
  '';

  # project does find_package(RapidJson) instead of find_package(RapidJSON)
  cmakeFlags = [ "-Wno-dev" ];

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    alsa-lib
    boost
    curl
    eigen
    freeimage
    freetype
    libGL
    libGLU
    libarchive
    pugixml
    rapidjson
    SDL2
    vlc
  ];

  postInstall = ''
    cp -r $src/resources $out/
  '';

  meta = {
    description = "A flexible emulator front-end supporting keyboardless navigation and custom system themes";
    homepage = "https://retropie.org/";
    maintainers = [ lib.maintainers.edwtjo ];
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
  };
}

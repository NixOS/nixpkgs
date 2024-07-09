{ cmake
, fetchFromGitHub
, jazz2-content
, lib
, libopenmpt
, libvorbis
, openal
, SDL2
, stdenv
, testers
, zlib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "jazz2";
  version = "2.7.0";

  src = fetchFromGitHub {
    owner = "deathkiller";
    repo = "jazz2-native";
    rev = finalAttrs.version;
    hash = "sha256-iy5b5h6wpOlubtOwBs0X7P0wBD3QeAQwjMhgnd4YP+Q=";
  };

  patches = [ ./nocontent.patch ];

  nativeBuildInputs = [ cmake ];
  buildInputs = [ libopenmpt libvorbis openal SDL2 zlib ];

  cmakeFlags = [
    "-DLIBOPENMPT_INCLUDE_DIR=${lib.getDev libopenmpt}/include/libopenmpt"
    "-DNCINE_DOWNLOAD_DEPENDENCIES=OFF"
    "-DNCINE_OVERRIDE_CONTENT_PATH=${jazz2-content}"
  ];

  passthru.tests.version = testers.testVersion {
    package = finalAttrs.finalPackage;
  };

  meta = with lib; {
    description = "Open-source Jazz Jackrabbit 2 reimplementation";
    homepage = "https://github.com/deathkiller/jazz2-native";
    license = licenses.gpl3Only;
    mainProgram = "jazz2";
    maintainers = with maintainers; [ surfaceflinger ];
    platforms = platforms.linux;
  };
})

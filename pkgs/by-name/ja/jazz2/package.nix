{ cmake
, fetchFromGitHub
, glfw
, jazz2-content
, lib
, libopenmpt
, libvorbis
, openal
, SDL2
, stdenv
, testers
, zlib
, graphicsLibrary ? "GLFW"
}:

assert lib.assertOneOf "graphicsLibrary" graphicsLibrary [ "SDL2" "GLFW" ];
stdenv.mkDerivation (finalAttrs: {
  pname = "jazz2";
  version = "2.4.1";

  src = fetchFromGitHub {
    owner = "deathkiller";
    repo = "jazz2-native";
    rev = finalAttrs.version;
    hash = "sha256-AbB7xtdyin/VySswHoPRq9LmhHLUJfetXqtIxEw+KSI=";
  };

  patches = [ ./nocontent.patch ];

  nativeBuildInputs = [ cmake ];
  buildInputs = [ libopenmpt libvorbis openal zlib ]
  ++ lib.optionals (graphicsLibrary == "GLFW") [ glfw ]
  ++ lib.optionals (graphicsLibrary == "SDL2") [ SDL2 ];

  cmakeFlags = [
    "-DLIBOPENMPT_INCLUDE_DIR=${lib.getDev libopenmpt}/include/libopenmpt"
    "-DNCINE_DOWNLOAD_DEPENDENCIES=OFF"
    "-DNCINE_OVERRIDE_CONTENT_PATH=${jazz2-content}"
  ] ++ lib.optionals (graphicsLibrary == "GLFW") [
    "-DGLFW_INCLUDE_DIR=${glfw}/include/GLFW"
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

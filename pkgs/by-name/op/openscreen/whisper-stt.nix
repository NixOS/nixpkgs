# The on-device speech-to-text server behind captions. The model is downloaded at runtime.
{
  lib,
  stdenv,
  cmake,
  fetchFromGitHub,
  version,
  src,
}:
let
  # The pins of electron/native/whisper-stt/CMakeLists.txt, handed to FetchContent.
  whisper = fetchFromGitHub {
    owner = "ggml-org";
    repo = "whisper.cpp";
    tag = "v1.9.1";
    hash = "sha256-tQtmTZTCw8f5u54MKSjlPzPRUwEeXvyDSsPjgSqu9dY=";
  };
  httplib = fetchFromGitHub {
    owner = "yhirose";
    repo = "cpp-httplib";
    tag = "v0.18.1";
    hash = "sha256-NLSflHzxXby+SpLFg32BfRafey48DZ0XULQeyHQJHP4=";
  };
  json = fetchFromGitHub {
    owner = "nlohmann";
    repo = "json";
    tag = "v3.11.3";
    hash = "sha256-7F0Jon+1oWL7uqet5i1IgHX0fUw/+z0QwEcA3zs5xHg=";
  };
in
stdenv.mkDerivation {
  pname = "openscreen-whisper-stt";
  inherit version src;
  sourceRoot = "${src.name}/electron/native/whisper-stt";

  nativeBuildInputs = [ cmake ];

  # Vulkan shader generation exhausts the build sandbox; captions run on the CPU backend.
  cmakeFlags = [
    (lib.cmakeBool "OSC_ENABLE_VULKAN" false)
    (lib.cmakeBool "FETCHCONTENT_FULLY_DISCONNECTED" true)
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_WHISPER" "${whisper}")
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_HTTPLIB" "${httplib}")
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_JSON" "${json}")
  ];

  # CMakeLists sets the RPATH to $ORIGIN: the server and its libraries share one directory.
  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    cp whisper-stt-server $out/bin/
    find . -name '*.so' -o -name '*.so.*' | xargs -r cp -t $out/bin/
    runHook postInstall
  '';

  meta = {
    description = "On-device speech-to-text server for OpenScreen captions";
    homepage = "https://github.com/getopenscreen/openscreen";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    mainProgram = "whisper-stt-server";
  };
}

{
  cmake,
  curl,
  fetchFromGitHub,
  gitUpdater,
  jazz2-content,
  lib,
  libGL,
  libopenmpt,
  libvorbis,
  openal,
  SDL2,
  stdenv,
  versionCheckHook,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "jazz2";
  version = "3.4.0";

  src = fetchFromGitHub {
    owner = "deathkiller";
    repo = "jazz2-native";
    tag = finalAttrs.version;
    hash = "sha256-96NiBE0/sBnIdajKui3pZmR8IGlElbeoyqYEYFWtOuM=";
  };

  patches = [ ./nocontent.patch ];

  strictDeps = true;
  nativeBuildInputs = [ cmake ];
  buildInputs = [
    curl
    libGL
    libopenmpt
    libvorbis
    openal
    SDL2
    zlib
  ];

  cmakeFlags = [
    (lib.cmakeBool "NCINE_DOWNLOAD_DEPENDENCIES" false)
    (lib.cmakeFeature "LIBOPENMPT_INCLUDE_DIR" "${lib.getDev libopenmpt}/include/libopenmpt")
    (lib.cmakeFeature "NCINE_OVERRIDE_CONTENT_PATH" "${jazz2-content}")
  ];

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru = {
    updateScript = gitUpdater { };
  };

  meta = {
    description = "Open-source Jazz Jackrabbit 2 reimplementation";
    homepage = "https://github.com/deathkiller/jazz2-native";
    license = lib.licenses.gpl3Only;
    mainProgram = "jazz2";
    maintainers = with lib.maintainers; [ surfaceflinger ];
    platforms = lib.platforms.linux;
  };
})

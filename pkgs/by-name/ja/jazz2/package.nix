{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  jazz2-content,
  curl,
  libopenmpt,
  libvorbis,
  openal,
  SDL2,
  libGL,
  zlib,
  versionCheckHook,
  gitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "jazz2";
  version = "3.3.0";

  src = fetchFromGitHub {
    owner = "deathkiller";
    repo = "jazz2-native";
    tag = finalAttrs.version;
    hash = "sha256-dj+BEAx626vSPy26+Ip3uaj3SBE1SWkfbh5P8U0iXsg=";
  };

  patches = [ ./nocontent.patch ];

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
    (lib.cmakeFeature "LIBOPENMPT_INCLUDE_DIR" "${lib.getDev libopenmpt}/include/libopenmpt")
    (lib.cmakeBool "NCINE_DOWNLOAD_DEPENDENCIES" false)
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

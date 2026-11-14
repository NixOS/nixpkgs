{
  cmake,
  fetchFromGitHub,
  ffmpeg_4,
  help2man,
  lib,
  popt,
  stdenv,
  versionCheckHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "nordlicht";
  version = "0.4.5";

  src = fetchFromGitHub {
    owner = "nordlicht";
    repo = "nordlicht";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Pdr9ggJxFeEdZcKnFvfmJ8u3Ejo4G6tRnBHg/d0/xZA=";
  };

  nativeBuildInputs = [
    cmake
    help2man
  ];

  buildInputs = [
    ffmpeg_4
    popt
  ];

  cmakeFlags = [
    (lib.cmakeFeature "CMAKE_POLICY_VERSION_MINIMUM" "3.5")
  ];

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  meta = {
    description = "Create colorful timebars from video and audio files";
    homepage = "https://nordlicht.github.io/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ aiyion ];
    mainProgram = "nordlicht";
  };
})

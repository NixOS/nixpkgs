{
  cmake,
  enableVmaf ? true,
  fetchFromGitHub,
  gitUpdater,
  lib,
  libvmaf,
  perl,
  pkg-config,
  python3,
  stdenv,
  versionCheckHook,
  yasm,
  ...
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "avm";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "AOMediaCodec";
    repo = "avm";
    tag = "v${finalAttrs.version}";
    hash = "sha256-dmMQfOP71DdjHZw6DpbiiOB5a9khIu6QnZ0F5WsMuM8=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [
    cmake
    perl
    pkg-config
    python3
    yasm
  ];

  propagatedBuildInputs = lib.optional enableVmaf libvmaf;
  cmakeFlags = [
    (lib.cmakeFeature "CMAKE_INSTALL_BINDIR" "bin")
    (lib.cmakeFeature "CMAKE_INSTALL_INCLUDEDIR" "include")
    (lib.cmakeFeature "CMAKE_INSTALL_LIBDIR" "lib")
  ]
  ++ (lib.optional enableVmaf (lib.cmakeFeature "CONFIG_TUNE_VMAF" "1"));

  passthru.updateScript = gitUpdater {
    rev-prefix = "v";
  };

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  meta = {
    homepage = "https://github.com/AOMediaCodec/avm";
    description = "AVM (AOM Video Model) is the reference software for AV2 codec from Alliance for Open Media";
    changelog = "https://github.com/AOMediaCodec/avm/blob/${finalAttrs.src.tag}/CHANGELOG";
    license = lib.licenses.bsd3Clear;
    maintainers = with lib.maintainers; [ VlaDexa ];
    mainProgram = "avmenc";
  };
})

{
  lib,
  fetchFromGitHub,
  rustPlatform,
  openssl,
  pkg-config,
  alsa-lib,
  systemdLibs,
  libxkbcommon,
  makeWrapper,
  versionCheckHook,
  # hardware acceleration can be enabled by overriding whisper-cpp/onnxruntime or by editing config.cudaSupport/config.rocmSupport globals
  whisper-cpp,
  onnxruntime,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "hyprwhspr-rs";
  version = "0.3.20";

  src = fetchFromGitHub {
    owner = "better-slop";
    repo = "hyprwhspr-rs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-QCOzTbLBoygOLLN90840HHHFEaHdorf0CQOCuGpCIfo=";
  };

  cargoHash = "sha256-hLjWHMY2wpEfPfLIdfxDI21FrrC1QOWGRkTezkmzmGY=";

  nativeBuildInputs = [
    pkg-config
    makeWrapper
  ];

  buildInputs = [
    openssl
    alsa-lib
    onnxruntime
    systemdLibs
    libxkbcommon
  ];

  postInstall = ''
    wrapProgram $out/bin/hyprwhspr-rs \
      --prefix PATH : ${lib.makeBinPath [ whisper-cpp ]}
    # default voice activation sounds
    install -Dm644 assets/* -t $out/share/assets
  '';

  # provide onnx runtime libraries to prevent default behavior of downloading them during the build step
  env = {
    ORT_STRATEGY = "system";
    ORT_LIB_LOCATION = "${lib.getLib onnxruntime}/lib";
    ORT_PREFER_DYNAMIC_LINK = "1";
  };

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  meta = {
    description = "Native speech-to-text voice dictation for Hyprland";
    homepage = "https://github.com/better-slop/hyprwhspr-rs";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    mainProgram = "hyprwhspr-rs";
    maintainers = with lib.maintainers; [ CodeF53 ];
  };
})

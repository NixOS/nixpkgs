{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchurl,
  rustPlatform,
  libcosmicAppHook,
  pkg-config,
  protobuf,
  just,
  alsa-lib,
  libjack2,
  pipewire,
  aws-lc,
  android-tools,
  versionCheckHook,
  nix-update-script,
}:

let
  rnnoiseModel = fetchurl {
    url = "https://media.xiph.org/rnnoise/models/rnnoise_data-0a8755f8e2d834eff6a54714ecc7d75f9932e845df35f8b59bc52a7cfe6e8b37.tar.gz";
    hash = "sha256-CodV+OLYNO/2pUcU7MfXX5ky6EXfNfi1m8UqfP5uizc=";
  };
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "android-mic";
  version = "2.2.12";

  src = fetchFromGitHub {
    owner = "teamclouday";
    repo = "AndroidMic";
    tag = finalAttrs.version;
    hash = "sha256-02/UWOMYEPGwifWKZLrdhnaErs3U7e98QQzuKV/LqPs=";
  };

  sourceRoot = "${finalAttrs.src.name}/RustApp";

  postPatch = ''
    substituteInPlace justfile \
      --replace-fail '`git rev-parse --short HEAD`' '"${finalAttrs.version}"'
  '';

  cargoHash = "sha256-sy1JuEt0hIz3B/KppBJLUgbostpRbfCtCm/yv21dJbU=";

  __structuredAttrs = true;

  nativeBuildInputs = [
    libcosmicAppHook
    rustPlatform.bindgenHook
    pkg-config
    protobuf
    just
  ];

  buildInputs = [
    alsa-lib
    libjack2
    pipewire
    aws-lc
  ];

  env = {
    PROTOC = lib.getExe protobuf;
    ANDROID_MIC_COMMIT = finalAttrs.version;
    RNNOISE_MODEL_PATH = "${rnnoiseModel}";
  };

  dontUseJustBuild = true;
  dontUseJustCheck = true;

  justFlags = [
    "--set"
    "prefix"
    (placeholder "out")
    "--set"
    "cargo-target-dir"
    "target/${stdenv.hostPlatform.rust.cargoShortTarget}"
  ];

  preFixup = ''
    libcosmicAppWrapperArgs+=(--prefix PATH : ${lib.makeBinPath [ android-tools ]})
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Use your Android phone as a microphone for your PC";
    homepage = "https://github.com/teamclouday/AndroidMic";
    changelog = "https://github.com/teamclouday/AndroidMic/releases/tag/${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ irgendeinwer ];
    platforms = lib.platforms.linux;
    mainProgram = "android-mic";
  };
})

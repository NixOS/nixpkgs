{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  nix-update-script,
  onnxruntime,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "icm";
  version = "0.10.50";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "rtk-ai";
    repo = "icm";
    tag = "icm-v${finalAttrs.version}";
    hash = "sha256-zaKpKMVH2vzUk0ryWupE4ByqqcmAdJwAe5ybb2TNlvM=";
  };

  cargoHash = "sha256-5NcmFaRqDla2ei694fJiqNr5n4V3A/ai3/9fzBHNa3s=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
    onnxruntime
  ];

  # Build the HTTP dashboard
  buildFeatures = [ "web" ];

  env = {
    # Use system OpenSSL instead of vendoring it
    OPENSSL_NO_VENDOR = "1";
    # Point ort (ONNX Runtime bindings) at the system library
    ORT_STRATEGY = "system";
    ORT_LIB_LOCATION = "${lib.getLib onnxruntime}/lib";
  };

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "^icm-(.*)"
    ];
  };

  meta = {
    description = "Permanent memory system for AI agents with MCP integration";
    homepage = "https://github.com/rtk-ai/icm";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ jpds ];
    mainProgram = "icm";
    platforms = lib.platforms.unix;
    broken = stdenv.hostPlatform.isDarwin;
  };
})

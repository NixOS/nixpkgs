{
  lib,
  rustPlatform,
  fetchFromGitHub,
  git,
  makeBinaryWrapper,
  pkg-config,
  openssl,
  nix-update-script,
  onnxruntime,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "icm";
  version = "0.10.61";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "rtk-ai";
    repo = "icm";
    tag = "icm-v${finalAttrs.version}";
    hash = "sha256-dIZxq29umqRt81g0Y7RY90oAgf+ockrKfwPvFd8k8tU=";
  };

  cargoHash = "sha256-1YZ1GYnRxxbXXIG7d0+Nd8z2MhL8JQuuLexWNCmA+Ic=";

  nativeBuildInputs = [
    makeBinaryWrapper
    pkg-config
  ];

  buildInputs = [
    openssl
    onnxruntime
  ];

  # Build the HTTP dashboard
  buildFeatures = [ "web" ];

  # The project-detection tests shell out to `git` (init, worktree add, ...)
  nativeCheckInputs = [
    git
  ];

  postInstall = ''
    wrapProgram $out/bin/icm \
      --suffix PATH : ${lib.makeBinPath [ git ]}
  '';
  env = {
    # Use system OpenSSL instead of vendoring it
    OPENSSL_NO_VENDOR = "1";
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
    changelog = "https://github.com/rtk-ai/icm/releases/tag/icm-v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ jpds ];
    mainProgram = "icm";
    platforms = lib.platforms.unix;
    badPlatforms = lib.platforms.darwin;
  };
})

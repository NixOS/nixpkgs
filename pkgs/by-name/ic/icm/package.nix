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
  oniguruma,
  sqlite,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "icm";
  version = "0.11.5";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "rtk-ai";
    repo = "icm";
    tag = "icm-v${finalAttrs.version}";
    hash = "sha256-u8EQraSq3U3jL3W2LEJwpucXphoPSSgJBGnhAu+HZJU=";
  };

  cargoHash = "sha256-Vu/I7z/sD0nE6qjyKFsUz9swa8N4w+TY6dtU342pnQQ=";

  nativeBuildInputs = [
    makeBinaryWrapper
    pkg-config
  ];

  buildInputs = [
    openssl
    onnxruntime
    oniguruma
    sqlite
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
    # ort-sys 2.0.0-rc.13 links statically unless told otherwise
    ORT_PREFER_DYNAMIC_LINK = "1";
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

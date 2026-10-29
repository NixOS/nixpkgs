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
  version = "0.10.63";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "rtk-ai";
    repo = "icm";
    tag = "icm-v${finalAttrs.version}";
    hash = "sha256-gj0zqfJWrn9LyYTSi2IdIP01yDs6aQvlsFUZQ9pBokI=";
  };

  cargoHash = "sha256-f+j9SmxI046GFscyBwuZxwMZOtUk3cTePlCI6QIa+xw=";

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

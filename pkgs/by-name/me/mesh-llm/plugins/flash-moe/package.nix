{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  buildPackages,
  pkg-config,
  openssl,
  nix-update-script,
  mesh-llm,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "mesh-llm-flash-moe-plugin";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "Mesh-LLM";
    repo = "flash-moe-plugin";
    tag = "v${finalAttrs.version}";
    hash = "sha256-yyYlN8EyNiuOcA/6KqgMDDnY2mg9UCVMwFsOKpAK0T0=";
  };

  cargoHash = "sha256-UnJEI+1sVUerGPDN87U9u9ssFylD4f3QRsdT44M01zI=";

  __structuredAttrs = true;

  # Otherwise mesh-llm-plugin's build script runs a prebuilt protoc.
  env.PROTOC = lib.getExe' buildPackages.protobuf "protoc";

  # reqwest's TLS uses OpenSSL except on macOS, which has its own.
  nativeBuildInputs = lib.optionals (!stdenv.hostPlatform.isDarwin) [ pkg-config ];

  buildInputs = lib.optionals (!stdenv.hostPlatform.isDarwin) [ openssl ];

  passthru = {
    # The name the plugin reports to the host, which must match its [[plugin]] entry.
    pluginName = "flash-moe";
    updateScript = nix-update-script { };
    # Without a server URL or backend command the plugin refuses to start.
    testSettings.url = "http://127.0.0.1:8000/v1";
    tests.starts = mesh-llm.tests.plugins;
  };

  meta = {
    description = "Flash-MoE inference endpoint plugin for MeshLLM";
    longDescription = ''
      Serves a Flash-MoE server's OpenAI-compatible endpoint to the mesh. Flash-MoE
      itself isn't included; its inference engine uses Apple's Metal, so on Linux
      the plugin can only attach to a server on another machine.
    '';
    homepage = "https://github.com/Mesh-LLM/flash-moe-plugin";
    changelog = "https://github.com/Mesh-LLM/flash-moe-plugin/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ kleinbem ];
    mainProgram = "flash-moe";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})

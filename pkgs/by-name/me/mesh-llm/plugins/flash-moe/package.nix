{
  lib,
  rustPlatform,
  fetchFromGitHub,
  buildPackages,
  pkg-config,
  openssl,
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
  strictDeps = true;

  # Otherwise mesh-llm-plugin's build script runs a prebuilt protoc.
  env.PROTOC = lib.getExe' buildPackages.protobuf "protoc";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ];

  passthru = {
    # The name the plugin reports to the host, which must match its [[plugin]] entry.
    pluginName = "flash-moe";
    protocolVersion = 3;
  };

  meta = {
    description = "Flash-MoE inference endpoint plugin for MeshLLM";
    homepage = "https://github.com/Mesh-LLM/flash-moe-plugin";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ kleinbem ];
    mainProgram = "flash-moe";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})

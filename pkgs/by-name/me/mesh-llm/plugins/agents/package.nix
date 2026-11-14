{
  lib,
  rustPlatform,
  fetchFromGitHub,
  buildPackages,
  pkg-config,
  sqlite,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "mesh-llm-agents-plugin";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "Mesh-LLM";
    repo = "agents-plugin";
    tag = "v${finalAttrs.version}";
    hash = "sha256-hwhNXrYGbgw9o0FA+VdN+qUBc/dBqU7F53I6MNcFNPg=";
  };

  cargoHash = "sha256-c5g8/larS/V9FM96kJ5xEwAriFGLaQTdlAoTFPEIeKE=";

  __structuredAttrs = true;
  strictDeps = true;

  # Otherwise mesh-llm-plugin's build script runs a prebuilt protoc.
  env.PROTOC = lib.getExe' buildPackages.protobuf "protoc";

  # rusqlite's libsqlite3-sys finds SQLite through pkg-config.
  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ sqlite ];

  passthru = {
    # The name the plugin reports to the host, which must match its [[plugin]] entry.
    pluginName = "agents";
    protocolVersion = 3;
  };

  meta = {
    description = "Mesh-native A2A agents and MCP tooling plugin for MeshLLM";
    homepage = "https://github.com/Mesh-LLM/agents-plugin";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ kleinbem ];
    mainProgram = "agents";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})

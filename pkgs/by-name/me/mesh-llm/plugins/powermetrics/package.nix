{
  lib,
  rustPlatform,
  fetchFromGitHub,
  buildPackages,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "mesh-llm-powermetrics-plugin";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "Mesh-LLM";
    repo = "powermetrics-plugin";
    tag = "v${finalAttrs.version}";
    hash = "sha256-mhPus0ahpyLWmmiHZ5sS1YFAC5CI7zDOsJLjXwy3o7w=";
  };

  cargoHash = "sha256-yzB5tKBTNu9PhfrybKMtP0zKNWJSzEghbDH3QVjZn3k=";

  __structuredAttrs = true;
  strictDeps = true;

  # Otherwise mesh-llm-plugin's build script runs a prebuilt protoc.
  env.PROTOC = lib.getExe' buildPackages.protobuf "protoc";

  passthru = {
    # The name the plugin reports to the host, which must match its [[plugin]] entry.
    pluginName = "powermetrics-plugin";
    protocolVersion = 3;
  };

  meta = {
    description = "Energy per output token from GPU power and local inference plugin for MeshLLM";
    homepage = "https://github.com/Mesh-LLM/powermetrics-plugin";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ kleinbem ];
    mainProgram = "powermetrics-plugin";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})

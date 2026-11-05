{
  lib,
  rustPlatform,
  fetchFromGitHub,
  buildPackages,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "mesh-llm-metrics-plugin";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "Mesh-LLM";
    repo = "metrics-plugin";
    tag = "v${finalAttrs.version}";
    hash = "sha256-G23FKj5LVFUg0Om9v7aPLHsSbZ2js+vz6bekIPICnwY=";
  };

  cargoHash = "sha256-TAn0G4k/Wfi/t9hnWXjIKcpzVLHC3lnpL9IqabBa3n0=";

  __structuredAttrs = true;
  strictDeps = true;

  # Otherwise mesh-llm-plugin's build script runs a prebuilt protoc.
  env.PROTOC = lib.getExe' buildPackages.protobuf "protoc";

  passthru = {
    # The name the plugin reports to the host, which must match its [[plugin]] entry.
    pluginName = "metrics";
    protocolVersion = 3;
  };

  meta = {
    description = "Metrics capability plugin for MeshLLM";
    homepage = "https://github.com/Mesh-LLM/metrics-plugin";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ kleinbem ];
    mainProgram = "metrics";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})

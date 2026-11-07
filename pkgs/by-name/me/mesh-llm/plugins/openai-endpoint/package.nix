{
  lib,
  rustPlatform,
  fetchFromGitHub,
  buildPackages,
  pkg-config,
  openssl,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "mesh-llm-openai-endpoint-plugin";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "Mesh-LLM";
    repo = "openai-endpoint-plugin";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Dkxckn9l4JkAGATVRAHVZVB52icYXkRtQCvtncTh7QU=";
  };

  cargoHash = "sha256-BJ7g4i5L6wTyvKg+M+W60Br72+VFDK++YE3ITPa9q6U=";

  __structuredAttrs = true;
  strictDeps = true;

  # The mesh-llm-plugin this release pins runs a prebuilt protoc even when
  # PROTOC is set; mesh-llm-plugin honours PROTOC since
  # https://github.com/Mesh-LLM/mesh-llm/pull/2448. Drop with a release that
  # pins a newer one.
  postPatch = ''
    substituteInPlace "$cargoDepsCopy"/*/mesh-llm-plugin-*/build.rs \
      --replace-fail 'unsafe { std::env::set_var("PROTOC", protoc) };' \
                     'if std::env::var_os("PROTOC").is_none() { unsafe { std::env::set_var("PROTOC", protoc) }; }'
  '';

  env.PROTOC = lib.getExe' buildPackages.protobuf "protoc";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ];

  passthru = {
    # The name the plugin reports to the host, which must match its [[plugin]] entry.
    pluginName = "openai-endpoint";
    protocolVersion = 3;
  };

  meta = {
    description = "Attach an OpenAI-compatible server to a MeshLLM mesh";
    homepage = "https://github.com/Mesh-LLM/openai-endpoint-plugin";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ kleinbem ];
    mainProgram = "openai-endpoint";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})

{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  buildPackages,
  pkg-config,
  openssl,
  nix-update-script,
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

  # The mesh-llm-plugin this release pins runs a prebuilt protoc even when
  # PROTOC is set (mesh-llm-plugin uses PROTOC since Mesh-LLM/mesh-llm#2448).
  # Drop with the openai-endpoint release that has https://github.com/Mesh-LLM/openai-endpoint-plugin/pull/6.
  postPatch = ''
    substituteInPlace "$cargoDepsCopy"/*/mesh-llm-plugin-*/build.rs \
      --replace-fail 'unsafe { std::env::set_var("PROTOC", protoc) };' \
                     'if std::env::var_os("PROTOC").is_none() { unsafe { std::env::set_var("PROTOC", protoc) }; }'
  '';

  env.PROTOC = lib.getExe' buildPackages.protobuf "protoc";

  # Only the tests' HTTP client (reqwest) needs OpenSSL; macOS uses its own TLS.
  nativeCheckInputs = lib.optionals (!stdenv.hostPlatform.isDarwin) [ pkg-config ];
  checkInputs = lib.optionals (!stdenv.hostPlatform.isDarwin) [ openssl ];

  passthru = {
    # The name the plugin reports to the host, which must match its [[plugin]] entry.
    pluginName = "openai-endpoint";
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Attach an OpenAI-compatible server to a MeshLLM mesh";
    homepage = "https://github.com/Mesh-LLM/openai-endpoint-plugin";
    changelog = "https://github.com/Mesh-LLM/openai-endpoint-plugin/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ kleinbem ];
    mainProgram = "openai-endpoint";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})

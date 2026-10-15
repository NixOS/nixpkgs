{
  lib,
  rustPlatform,
  fetchFromGitHub,
  cacert,
  onnxruntime,
  llama-cpp,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "ollaya";
  version = "0.12.1";

  src = fetchFromGitHub {
    owner = "ollaya-dev";
    repo = "ollaya";
    tag = "v${finalAttrs.version}";
    hash = "sha256-NDESJkL+VAETrKi4PNYKuFQJtaV0Eta7gaqOWdBNmAQ=";
  };

  cargoHash = "sha256-Xkwj8ATewNtIV7QbMaIYs+fb0xWgrjxCEiGTjPNAo/M=";

  buildInputs = [ onnxruntime ];

  __structuredAttrs = true;

  env = {
    ORT_STRATEGY = "system";
    ORT_LIB_LOCATION = "${lib.getLib onnxruntime}/lib";
    ORT_PREFER_DYNAMIC_LINK = "true";
  };

  # The client tests hit local mock servers, but reqwest refuses to build a client without a trust store.
  nativeCheckInputs = [ cacert ];

  # GGUF runners dlopen llama.cpp from here and refuse any version but the one pinned in
  # scripts/llama-cpp.sh, so llama-cpp must match it.
  postInstall = ''
    # ort's copy-dylibs duplicates onnxruntime next to the binary.
    rm $out/lib/libonnxruntime*
    mkdir -p $out/lib/ollaya
    ln -s ${lib.getLib llama-cpp}/lib $out/lib/ollaya/llama
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Run open decision models locally behind a TypeSafe-compatible API";
    homepage = "https://ollaya.dev";
    changelog = "https://github.com/ollaya-dev/ollaya/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ happysalada ];
    mainProgram = "ollaya";
    platforms = lib.platforms.linux;
  };
})

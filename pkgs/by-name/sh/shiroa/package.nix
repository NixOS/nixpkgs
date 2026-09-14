{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "shiroa";
  version = "0.3.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Myriad-Dreamin";
    repo = "shiroa";
    tag = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-V0epGbMe4NSZznVTkuke1Vd9FCwhE99YtuQFSoU9xh0=";
  };

  cargoHash = "sha256-G99uZ5u7eiKaMW9YwpMmsP7RbfEi/tTiK9RyHQHEtlQ=";

  cargoBuildFlags = [
    "--package"
    "shiroa"
  ];

  cargoTestFlags = finalAttrs.cargoBuildFlags;

  postInstall = ''
    install -Dm644 LICENSE "$out/share/licenses/shiroa/LICENSE"
    install -Dm644 assets/artifacts/LICENSE "$out/share/licenses/shiroa/artifacts/LICENSE"
    install -Dm644 assets/artifacts/NOTICE "$out/share/licenses/shiroa/artifacts/NOTICE"
    install -Dm644 themes/mdbook/LICENSE "$out/share/licenses/shiroa/mdbook/LICENSE"
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  meta = {
    description = "Simple tool for creating modern online books in pure Typst";
    homepage = "https://github.com/Myriad-Dreamin/shiroa";
    changelog = "https://github.com/Myriad-Dreamin/shiroa/releases/tag/v${finalAttrs.version}";
    license = with lib.licenses; [
      asl20
      bitstreamVera
      bsd0
      bsd3
      cc0
      cc-by-40
      gfl
      mit
      mpl20
      ofl
      ufl
    ];
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      binaryBytecode # WASM files in assets/artifacts
      obfuscatedCode # minified JavaScript in assets/artifacts
    ];
    maintainers = with lib.maintainers; [ _3w36zj6 ];
    mainProgram = "shiroa";
  };
})

{
  lib,
  stdenv,
  stdenvNoCC,
  autoPatchelfHook,
  alsa-lib,
  testers,
  vscode-utils,
  vscode-extension-update-script,
}:

vscode-utils.buildVscodeMarketplaceExtension (finalAttrs: {
  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [ autoPatchelfHook ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    (lib.getLib stdenv.cc.cc)
    alsa-lib
  ];

  mktplcRef =
    let
      sources = {
        "x86_64-linux" = {
          arch = "linux-x64";
          hash = "sha256-792UABRtJEpG4ipQsoiN1lkGeaNqHyg69Sv3g26BZBA=";
          signatureHash = "sha256-nEF9JKIyuJOo1porjjdupLUwOOTUxgcEzZNNVLRNBPQ=";
        };
        "aarch64-linux" = {
          arch = "linux-arm64";
          hash = "sha256-NDiCBtQ/BWPPOAbDs/ACZ68at0gAqJJMPBLCsILnBho=";
          signatureHash = "sha256-wNl2Zli7QaXBI9j2Ec/ue5vLlQe3TGZCkVmQSIxa4Kw=";
        };
        "x86_64-darwin" = {
          arch = "darwin-x64";
          hash = "sha256-j81bcYqopNTAO/faiugARwAaVZ8s+1Atf8oHDTS8fR4=";
          signatureHash = "sha256-r7puhlgKwooRUg1+Mj+Efp1CPwHrxeBprCwEL4obYQs=";
        };
        "aarch64-darwin" = {
          arch = "darwin-arm64";
          hash = "sha256-Y6M110iwzKdzJoHb6zEKWyR4NyxyQtuvNJ4ucOrUYdY=";
          signatureHash = "sha256-GGbiWtyeW+vDVx/7hyDk4LJ5iJTnv2HZK3MvDqCmCJs=";
        };
      };
    in
    {
      name = "claude-code";
      publisher = "anthropic";
      version = "2.1.170";
    }
    // sources.${stdenvNoCC.hostPlatform.system}
      or (throw "Unsupported system ${stdenvNoCC.hostPlatform.system}");

  passthru.tests.bundled-claude-runs = testers.testVersion {
    package = finalAttrs.finalPackage;
    command = "${finalAttrs.finalPackage}/share/vscode/extensions/anthropic.claude-code/resources/native-binary/claude --version";
  };

  meta = {
    description = "Harness the power of Claude Code without leaving your IDE";
    homepage = "https://docs.anthropic.com/s/claude-code";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=anthropic.claude-code";
    license = lib.licenses.unfree;
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
    maintainers = with lib.maintainers; [ xiaoxiangmoe ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
  };
})

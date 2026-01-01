{
  lib,
  vscode-utils,
}:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "claude-code";
    publisher = "anthropic";
<<<<<<< HEAD
    version = "2.0.75";
    hash = "sha256-PA7eL4TZTFYVlImXnZCw6aWjrLXl7/KndnkU3D2t1jw=";
=======
    version = "2.0.55";
    hash = "sha256-6ip1ETRDQTjl5bxIGPHTFAL8Ri5xbN2zd6hVVdTnjtE=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  meta = {
    description = "Harness the power of Claude Code without leaving your IDE";
    homepage = "https://docs.anthropic.com/s/claude-code";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=anthropic.claude-code";
    license = lib.licenses.unfree;
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
    maintainers = with lib.maintainers; [ xiaoxiangmoe ];
  };
}

{
  lib,
  vscode-utils,
}:

vscode-utils.buildVscodeMarketplaceExtension (finalAttrs: {
  mktplcRef = {
    name = "amazon-q-vscode";
    publisher = "AmazonWebServices";
    version = "1.75.0";
    hash = "sha256-a6Hvk3q8nqHgjZujuEcJ6UlspJpXeLPNtFl0n1A+Wu0=";
  };

  meta = {
    changelog = "https://github.com/aws/aws-toolkit-vscode/releases/tag/amazonq%2Fv${finalAttrs.version}";
    description = "Amazon Q, CodeCatalyst, Local Lambda debug, SAM/CFN syntax, ECS Terminal, AWS resources";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=AmazonWebServices.amazon-q-vscode";
    homepage = "https://github.com/aws/aws-toolkit-vscode";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ drupol ];
  };
})

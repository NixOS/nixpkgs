{
  lib,
  vscode-utils,
}:

vscode-utils.buildVscodeMarketplaceExtension (finalAttrs: {
  mktplcRef = {
    name = "amazon-q-vscode";
    publisher = "AmazonWebServices";
    version = "1.90.0";
    hash = "sha256-9z8EB5jMtpmQadbX0usWUlbs/n87wX9dJcyrveKqyJ8=";
  };

  meta = {
    changelog = "https://github.com/aws/aws-toolkit-vscode/releases/tag/amazonq%2Fv${finalAttrs.version}";
    description = "Amazon Q, CodeCatalyst, Local Lambda debug, SAM/CFN syntax, ECS Terminal, AWS resources";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=AmazonWebServices.amazon-q-vscode";
    homepage = "https://github.com/aws/aws-toolkit-vscode";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ ];
  };
})

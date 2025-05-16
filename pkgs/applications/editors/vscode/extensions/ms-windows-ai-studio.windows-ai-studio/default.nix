{
  lib,
  vscode-utils,
}:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "windows-ai-studio";
    publisher = "ms-windows-ai-studio";
    version = "0.12.1";
    hash = "sha256-uj+4o5gH6qfYCJjapoas/JDWymFWSl4kHFu5Ys9rTlU=";
  };

  meta = {
    description = "A Visual Studio Code an extension to help developers and AI engineers to easily build AI apps through developing and testing with generative AI models locally or in the cloud";
    homepage = "https://github.com/Microsoft/windows-ai-studio";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ drupol ];
  };
}

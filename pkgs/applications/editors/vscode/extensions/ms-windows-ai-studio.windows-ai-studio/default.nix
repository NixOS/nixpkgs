{
  lib,
  vscode-utils,
}:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "windows-ai-studio";
    publisher = "ms-windows-ai-studio";
    version = "0.6.1";
    hash = "sha256-BAA7wSfyJ4y8how+NnaGdCf/BCU6aOmI8ew8qpcQCnY=";
  };

  meta = {
    description = "A Visual Studio Code an extension to help developers and AI engineers to easily build AI apps through developing and testing with generative AI models locally or in the cloud";
    homepage = "https://github.com/Microsoft/windows-ai-studio";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ drupol ];
  };
}

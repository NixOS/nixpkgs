{
  lib,
  vscode-utils,
}:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "windows-ai-studio";
    publisher = "ms-windows-ai-studio";
    version = "0.10.9";
    hash = "sha256-JhpPOnzFQmTtzyl5p/dqFH/tjJ4qsfJhdco6uLUpVN4=";
  };

  meta = {
    description = "A Visual Studio Code an extension to help developers and AI engineers to easily build AI apps through developing and testing with generative AI models locally or in the cloud";
    homepage = "https://github.com/Microsoft/windows-ai-studio";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ drupol ];
  };
}

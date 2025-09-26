{
  lib,
  vscode-utils,
}:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "geminicodeassist";
    publisher = "Google";
    version = "2.48.0";
    hash = "sha256-Pcq8NpfgokmyQmMO6fA0AU8/ytjdUFYBcIG2HsEBLaU=";
  };
  meta = {
    changelog = "https://marketplace.visualstudio.com/items/Google.geminicodeassist/changelog";
    description = "AI-assisted development powered by Gemini";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=Google.geminicodeassist";
    homepage = "https://gemini.google.com";
    license = lib.licenses.unfree;
    maintainers = [ lib.maintainers.flacks ];
  };
}

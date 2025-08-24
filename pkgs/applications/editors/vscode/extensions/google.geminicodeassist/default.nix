{
  lib,
  vscode-utils,
}:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "geminicodeassist";
    publisher = "Google";
    version = "2.44.0";
    hash = "sha256-hi72kyVYOWHA2SByzE7S/ITdrshCZQcvmbFyvyiTXss=";
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

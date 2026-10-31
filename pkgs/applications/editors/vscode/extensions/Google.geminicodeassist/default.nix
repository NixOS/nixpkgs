{
  lib,
  vscode-utils,
}:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    publisher = "Google";
    name = "geminicodeassist";
    version = "2.79.0";
    hash = "sha256-/8QmCFtD7f/RNkNuZexvoevpLa9FqrZfxqmPo2Ss4zk=";
  };

  meta = {
    description = "Gemini Code Assist: AI-first coding in your natural language in vscode!";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=Google.geminicodeassist";
    homepage = "https://codeassist.google/";
    license = lib.licenses.unfree; # https://developers.google.com/gemini-code-assist/resources/plugin-license?hl=en
    maintainers = [ ];
  };
}

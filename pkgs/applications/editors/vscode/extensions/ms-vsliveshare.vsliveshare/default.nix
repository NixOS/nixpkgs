{
  lib,
  vscode-utils,
  xsel,
}:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "vsliveshare";
    publisher = "ms-vsliveshare";
    version = "1.1.122";
    hash = "sha256-XD8iLG8HA9u5Y4CKQKLnmeAN4IFf1LGDvhTKuroxkHg=";
  };

  postPatch = ''
    substituteInPlace vendor.js \
      --replace-fail '"xsel"' '"${xsel}/bin/xsel"'
  '';

  meta = {
    description = "Real-time collaborative development for VS Code";
    homepage = "https://aka.ms/vsls-docs";
    changelog = "https://marketplace.visualstudio.com/items/MS-vsliveshare.vsliveshare/changelog";
    license = lib.licenses.unfree;
    maintainers = builtins.attrValues { inherit (lib.maintainers) jraygauthier V; };
  };
}

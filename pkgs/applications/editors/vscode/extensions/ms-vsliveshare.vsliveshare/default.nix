{
  lib,
  vscode-utils,
  xsel,
}:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "vsliveshare";
    publisher = "ms-vsliveshare";
    version = "1.0.5918";
    hash = "sha256-Tk0mKydUF8M7l7NC9wEA7t2rzJWy/mq4/HvIHI2/ldQ=";
  };

  postPatch = ''
    substituteInPlace extension.js \
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

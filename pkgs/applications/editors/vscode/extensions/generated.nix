{ buildVscodeMarketplaceExtension, lib }:
{
  _1Password.op-vscode = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "1Password";
      name = "op-vscode";
      version = "1.0.0";
      sha256 = "1q4wp3gkgv6lb0kq8qqvd2bzx52w8ya790dwzs8jp3waflzr7qk5";
    };
    meta.license = [ lib.licenses.mit ];
  };
}

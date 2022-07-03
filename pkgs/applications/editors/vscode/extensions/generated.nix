{ buildVscodeMarketplaceExtension, lib }:
{
  Arjun.swagger-viewer = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "Arjun";
      name = "swagger-viewer";
      version = "3.1.2";
      sha256 = "1cjvc99x1q5w3i2vnbxrsl5a1dr9gb3s6s9lnwn6mq5db6iz1nlm";
    };
  };
  alexdima.copy-relative-path = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "alexdima";
      name = "copy-relative-path";
      version = "0.0.2";
      sha256 = "06g601n9d6wyyiz659w60phgm011gn9jj5fy0gf5wpi2bljk3vcn";
    };
  };
  alygin.vscode-tlaplus = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "alygin";
      name = "vscode-tlaplus";
      version = "1.5.4";
      sha256 = "0mf98244z6wzb0vj6qdm3idgr2sr5086x7ss2khaxlrziif395dx";
    };
    meta.license = [ lib.licenses.mit ];
  };
  antfu.icons-carbon = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "antfu";
      name = "icons-carbon";
      version = "0.2.5";
      sha256 = "12bs9i8fj11irnfk1j5jxcly91xql3nspwxf0rpfgy7fx1dyanmx";
    };
    meta.license = [ lib.licenses.mit ];
  };
  antfu.slidev = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "antfu";
      name = "slidev";
      version = "0.3.3";
      sha256 = "0pqiwcvn5c8kwqlmz4ribwwra69gbiqvz41ig4fh29hkyh078rfk";
    };
    meta.license = [ lib.licenses.mit ];
  };
}

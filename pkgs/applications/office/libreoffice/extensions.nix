# Manually packaged extensions for azure-cli
#
# Checkout ./README.md for more information.

{
  lib,
  mkLibreOfficeExtension,
}:

{
  zotero-libreoffice-integration = mkLibreOfficeExtension rec {
    pname = "zotero-libreoffice-integration";
    version = "7.0.3";
    url = "https://archive.org/download/zotero-libre-office-integration/Zotero_LibreOffice_Integration.oxt";
    hash = "sha256-JyVWGrvyA5jwuqzzIpksYCwD5JXt8NI6IN/jFf11YIg=";
    meta = {
      description = "Zotero LibreOffice integration";
      homepage = "https://github.com/zotero/zotero-libreoffice-integration";
      license = lib.licenses.agpl2;
      sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
      maintainers = with lib.maintainers; [ onny ];
    };
  };

}

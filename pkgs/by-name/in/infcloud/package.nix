{
  lib,
  fetchzip,
}:
fetchzip {
  version = "0.13.1";
  pname = "infcloud";

  url = "https://inf-it.com/open-source/download/InfCloud_0.13.1.zip";
  hash = "sha256-OEZV1KWYua4HCVqtUMoPr1Y7a0DiO+2Lgy4tIBnQULo=";

  meta = {
    description = "Open source CalDAV/CardDAV web client";
    homepage = "https://inf-it.com/open-source/clients/infcloud/";
    license = [ lib.licenses.agpl3Plus ];
    maintainers = [ lib.maintainers.erictapen ];
  };
}

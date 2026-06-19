{
  lib,
  stdenv,
  fetchzip,
}:
stdenv.mkDerivation {
  version = "0.13.1";
  pname = "infcloud";

  src = fetchzip {
    url = "https://inf-it.com/open-source/download/InfCloud_0.13.1.zip";
    hash = "sha256-OEZV1KWYua4HCVqtUMoPr1Y7a0DiO+2Lgy4tIBnQULo=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out
    cp -r . $out/
    runHook postInstall
  '';

  meta = {
    description = "Open source CalDAV/CardDAV web client";
    homepage = "https://inf-it.com/open-source/clients/infcloud/";
    license = lib.licenses.agpl3Plus;
    maintainers = [ lib.maintainers.erictapen ];
  };
}

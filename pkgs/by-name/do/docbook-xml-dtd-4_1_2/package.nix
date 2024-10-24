{
  lib,
  fetchurl,
  findXMLCatalogs,
  stdenvNoCC,
  unzip,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "docbook-xml";
  version = "4.1.2";

  src = fetchurl {
    url = "https://docbook.org/xml/4.1.2/docbkx412.zip";
    hash = "sha256-MPBkQGTg6nF1FDglGUCxQx9GrK2oFKBihw9IbHcud3I=";
  };

  nativeBuildInputs = [ unzip ];

  propagatedNativeBuildInputs = [ findXMLCatalogs ];

  strictDeps = true;

  # src generates multiple folder on unzip, so we must override unpackCmd
  unpackCmd = ''
    mkdir -p out
    unzip $curSrc -d out
  '';

  installPhase =
    let
      # DocBook 4.1.2 lacks catalog.xml; let's hack the 4.2 one
      docbook42catalog = fetchurl {
        name = "docbook-xml-catalog-4.2";
        url = "https://docbook.org/xml/4.2/catalog.xml";
        downloadToTemp = true;
        postFetch = ''
          sed 's|V4\.2|V4.1.2|g' $downloadedFile > $out
        '';
        hash = "sha256-mCYGQaMUdDB85ar5wH+Xka75YP0xxIrJlsXBq/XDml0=";
      };
    in
    ''
      runHook preInstall

      mkdir -p $out/xml/dtd/docbook
      cp -r ./* $out/xml/dtd/docbook

      cp ${docbook42catalog} $out/xml/dtd/docbook/catalog.xml

      runHook postInstall
    '';

  postFixup = ''
    pushd $out/xml/dtd/docbook
    find . -type f -exec chmod -x {} \;
    popd
  '';

  meta = {
    homepage = "https://docbook.org/";
    description = "Semantic markup language for technical documentation";
    branch = finalAttrs.version;
    maintainers = with lib.maintainers; [ AndersonTorres ];
    platforms = lib.platforms.all;
  };
})

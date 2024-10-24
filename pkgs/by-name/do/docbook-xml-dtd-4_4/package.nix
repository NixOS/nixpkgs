{
  lib,
  fetchurl,
  findXMLCatalogs,
  stdenvNoCC,
  unzip,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "docbook-xml";
  version = "4.4";

  src = fetchurl {
    url = "https://docbook.org/xml/${finalAttrs.version}/docbook-xml-${finalAttrs.version}.zip";
    hash = "sha256-AvFZ64jEJU2V6DHFHBRLGGOyFtkJtf9FdDoc5vUnMJA=";
  };

  nativeBuildInputs = [ unzip ];

  propagatedNativeBuildInputs = [ findXMLCatalogs ];

  strictDeps = true;

  # src generates multiple folder on unzip, so we must override unpackCmd
  unpackCmd = ''
    mkdir -p out
    unzip $curSrc -d out
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/xml/dtd/docbook
    cp -r ./* $out/xml/dtd/docbook

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

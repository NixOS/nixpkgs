{
  version,
  url ? "https://docbook.org/xml/${version}/docbook-xml-${version}.zip",
  hash,
}:

{
  lib,
  stdenvNoCC,
  fetchurl,
  unzip,
  libxml2,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "docbook";
  inherit version;

  src = fetchurl {
    inherit url hash;
  };

  nativeBuildInputs = [
    unzip
    libxml2
  ];

  sourceRoot = ".";

  installPhase = ''
    runHook preInstall

    dst=$out/xml/dtd/docbook
    mkdir -p $dst

    cp -pr -t $dst *

    runHook postInstall
  '';

  fixupPhase = ''
    runHook preFixup

    substituteInPlace $dst/catalog.xml \
        --replace-fail uri=\" uri=\"$dst/

    runHook postFixup
  '';

  meta = {
    description = "General purpose XML and SGML document type";
    longDescription = ''
      DocBook is general purpose XML and SGML document type particularly well
      suited to books and papers about computer hardware and software (though it
      is by no means limited to these applications).

      The OASIS DocBook Technical Committee maintains the DocBook schema.
      DocBook is officially available as a Document Type Definition (DTD) for
      both XML and SGML. It is unofficially available in other forms as well.
    '';
    homepage = "https://docbook.org/";
    license = lib.licenses.free;
    maintainers = with lib.maintainers; [ rc-zb ];
    platforms = lib.platforms.all;
  };
})

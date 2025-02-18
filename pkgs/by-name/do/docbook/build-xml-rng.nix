{
  version,
  url ? "https://docs.oasis-open.org/docbook/docbook/v${version}/os/docbook-v${version}-os.zip",
  hash,
}:

{
  lib,
  stdenvNoCC,
  fetchurl,
  unzip,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "docbook";
  inherit version;

  src = fetchurl {
    inherit url hash;
  };

  nativeBuildInputs = [ unzip ];

  sourceRoot = ".";

  meta = {
    description = "General purpose XML schema";
    longDescription = ''
      DocBook is general purpose XML schema particularly well suited to books and
      papers about computer hardware and software (though it is by no means
      limited to these applications).

      The OASIS DocBook Technical Committee maintains the DocBook schema.
      Starting with V5.0, DocBook is normatively available as a RELAX NG Schema
      (with some additional Schematron assertions).
    '';
    homepage = "https://docbook.org/";
    license = "DocBook-Schema";
    maintainers = with lib.maintainers; [ rc-zb ];
    platforms = lib.platforms.all;
  };
})

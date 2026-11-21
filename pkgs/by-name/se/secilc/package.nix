{
  lib,
  stdenv,
  fetchurl,
  libsepol,
  xmlto,
  docbook_xml_dtd_42,
  docbook_xsl,
  findXMLCatalogs,
  checkpolicy,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "secilc";
  version = "3.11";
  inherit (libsepol) se_url;

  src = fetchurl {
    url = "${finalAttrs.se_url}/${finalAttrs.version}/secilc-${finalAttrs.version}.tar.gz";
    hash = "sha256-H7feAF01rgrG/4+PyVXQihW1waZ+lhuX75h1dq8NsRo=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [
    xmlto
    docbook_xml_dtd_42
    docbook_xsl
    findXMLCatalogs
  ];

  buildInputs = [ libsepol ];

  makeFlags = [
    "PREFIX=${placeholder "out"}"
  ];

  enableParallelBuilding = true;

  doCheck = true;
  checkTarget = "test";
  nativeCheckInputs = [ checkpolicy ];

  meta = {
    description = "SELinux Common Intermediate Language (CIL) compiler";
    homepage = "https://github.com/SELinuxProject/selinux";
    changelog = "https://github.com/SELinuxProject/selinux/releases/tag/${finalAttrs.version}";
    license = lib.licenses.bsd2;
    inherit (libsepol.meta) maintainers platforms;
    mainProgram = "secilc";
  };
})

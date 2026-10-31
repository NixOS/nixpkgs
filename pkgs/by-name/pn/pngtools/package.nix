{
  lib,
  stdenv,
  libpng,
  autoreconfHook,
  docbook2x,
  docbook_sgml_dtd_45,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pngtools";
  version = "1.3";

  src = fetchFromGitHub {
    owner = "mikalstill";
    repo = "pngtools";
    tag = "v${finalAttrs.version}";
    hash = "sha256-2V4er/33z3rII8HdnVgaggG0aZjWlFgsRuBWzhvL8cE=";
  };

  # we have docbook dtd 4.5 packaged, but not 4.4. 4.5 seems to work good enough.
  postPatch = ''
    substituteInPlace man/Makefile.am \
      --replace-fail "docbook2man" "docbook2man --sgml"
    sed -iE 's@DocBook V4.4@DocBook V4.5@g' man/*.sgml.in
  '';

  nativeBuildInputs = [
    autoreconfHook
    docbook2x
  ];

  env.SGML_CATALOG_FILES = lib.concatStringsSep ":" [
    "${docbook_sgml_dtd_45}/sgml/dtd/docbook-4.5/docbook.cat"
  ];

  buildInputs = [ libpng ];

  meta = {
    homepage = "https://github.com/mikalstill/pngtools";
    description = "PNG manipulation tools";
    maintainers = with lib.maintainers; [ zendo ];
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.all;
  };
})

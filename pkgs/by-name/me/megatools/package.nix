{
  lib,
  stdenv,
  fetchgit,
  asciidoc,
  docbook_xml_dtd_45,
  docbook2x,
  libxml2,
  meson,
  ninja,
  pkg-config,
  curl,
  glib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "megatools";
  version = "1.12.2";

  src = fetchgit {
    url = "https://xff.cz/git/megatools";
    rev = finalAttrs.version;
    hash = "sha256-7wzEfqBhqCs7QDmXZqq0DvC1J2xiw8hb9Yne7DC9U6g=";
  };

  nativeBuildInputs = [
    asciidoc
    docbook_xml_dtd_45
    docbook2x
    libxml2
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    curl
    glib
  ];

  enableParallelBuilding = true;
  strictDeps = true;

  meta = {
    description = "Command line client for Mega.co.nz";
    homepage = "https://xff.cz/megatools/";
    changelog = "https://xff.cz/megatools/builds/NEWS";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [
      viric
      vji
    ];
    platforms = lib.platforms.unix;
  };
})

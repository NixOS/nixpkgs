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
  fuse,
}:

stdenv.mkDerivation rec {
  pname = "megatools";
  version = "1.11.5";

  src = fetchgit {
    url = "https://xff.cz/git/megatools";
    rev = version;
    hash = "sha256-XOGjdvMw8wfhBwyOBnQqiiJeOGvYXKMYxiJ6BZeEwDQ=";
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
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ fuse ];

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
}

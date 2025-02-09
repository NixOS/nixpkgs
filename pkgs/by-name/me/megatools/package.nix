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
  version = "1.11.3";

  src = fetchgit {
    url = "https://xff.cz/git/megatools";
    rev = version;
    sha256 = "sha256-z2BUSNXl0u+28TzhLmNjcgNVLBmr3m+FuRWr8o/EINw=";
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
  ] ++ lib.optionals stdenv.hostPlatform.isLinux [ fuse ];

  enableParallelBuilding = true;
  strictDeps = true;

  meta = with lib; {
    description = "Command line client for Mega.co.nz";
    homepage = "https://megatools.megous.com/";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ viric ];
    platforms = platforms.unix;
  };
}

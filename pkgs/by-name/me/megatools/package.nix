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
  version = "1.11.1";

  src = fetchgit {
    url = "https://megous.com/git/megatools";
    rev = version;
    sha256 = "sha256-AdvQqaRTsKTqdfNfFiWtA9mIPVGuui+Ru9TUARVG0+Q=";
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

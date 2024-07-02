{
  lib,
  asciidoc,
  curl,
  docbook2x,
  docbook_xml_dtd_45,
  fetchgit,
  fuse,
  glib,
  libxml2,
  meson,
  ninja,
  pkg-config,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "megatools";
  version = "1.11.1";

  src = fetchgit {
    url = "https://megous.com/git/megatools";
    rev = finalAttrs.version;
    hash = "sha256-AdvQqaRTsKTqdfNfFiWtA9mIPVGuui+Ru9TUARVG0+Q=";
  };

  outputs = [ "out" "doc" "man" ];

  nativeBuildInputs = [
    asciidoc
    docbook2x
    docbook_xml_dtd_45
    libxml2
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    curl
    glib
  ] ++ lib.optionals stdenv.isLinux [
    fuse
  ];

  enableParallelBuilding = true;

  strictDeps = true;

  meta = {
    description = "Command line client for Mega.co.nz";
    homepage = "https://megatools.megous.com/";
    license = lib.licenses.gpl2Plus;
    mainProgram = "megatools";
    maintainers = with lib.maintainers; [ AndersonTorres ];
    platforms = lib.platforms.unix;
  };
}
)

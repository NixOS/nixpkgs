{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  fuse,
  glib,
  attr,
}:

stdenv.mkDerivation rec {
  pname = "ciopfs";
  version = "0.4";

  src = fetchurl {
    url = "https://www.brain-dump.org/projects/ciopfs/ciopfs-${version}.tar.gz";
    sha256 = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    fuse
    glib
    attr
  ];

  makeFlags = [
    "DESTDIR=$(out)"
    "PREFIX="
  ];

  meta = {
    homepage = "https://www.brain-dump.org/projects/ciopfs/";
    description = "Case-insensitive filesystem layered on top of any other filesystem";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.linux;
  };
}

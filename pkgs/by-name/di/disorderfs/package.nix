{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  fuse,
  attr,
  asciidoc-full,
}:

stdenv.mkDerivation rec {
  pname = "disorderfs";
  version = "0.5.11";

  src = fetchurl {
    url = "http://http.debian.net/debian/pool/main/d/disorderfs/disorderfs_${version}.orig.tar.bz2";
    sha256 = "sha256-KqAMKVUykCgVdNyjacZjpVXqVdeob76v0iOuSd4TNIY=";
  };

  nativeBuildInputs = [
    pkg-config
    asciidoc-full
  ];

  buildInputs = [
    fuse
    attr
  ];

  installFlags = [ "PREFIX=$(out)" ];

  meta = {
    description = "Overlay FUSE filesystem that introduces non-determinism into filesystem metadata";
    mainProgram = "disorderfs";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ pSub ];
  };
}

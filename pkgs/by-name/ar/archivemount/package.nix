{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  fuse,
  libarchive,
}:

stdenv.mkDerivation rec {
  pname = "archivemount";
  version = "0.9.1";

  src = fetchurl {
    url = "https://www.cybernoia.de/software/archivemount/archivemount-${version}.tar.gz";
    sha256 = "1cy5b6qril9c3ry6fv7ir87s8iyy5vxxmbyx90dm86fbra0vjaf5";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    fuse
    libarchive
  ];

  meta = {
    description = "Gateway between FUSE and libarchive: allows mounting of cpio, .tar.gz, .tar.bz2 archives";
    mainProgram = "archivemount";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.unix;
  };
}

{ lib
, stdenv
, fetchurl
, fetchpatch
, groff
}:

stdenv.mkDerivation rec {
  pname = "mktemp";
  version = "1.7";

  # Have `configure' avoid `/usr/bin/nroff' in non-chroot builds.
  NROFF = "${groff}/bin/nroff";

  patches = [
    # Pull upstream fix for parallel install failures.
    (fetchpatch {
      name = "parallel-install.patch";
      url = "https://www.mktemp.org/repos/mktemp/raw-rev/eb87d96ce8b7";
      hash = "sha256-cJ/0pFj8tOkByUwhlMwLNSQgTHyAU8svEkjKWWwsNmY=";
    })
  ];

  # Don't use "install -s"
  postPatch = ''
    substituteInPlace Makefile.in --replace " 0555 -s " " 0555 "
  '';

  src = fetchurl {
    url = "ftp://ftp.mktemp.org/pub/mktemp/mktemp-${version}.tar.gz";
    sha256 = "0x969152znxxjbj7387xb38waslr4yv6bnj5jmhb4rpqxphvk54f";
  };

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Simple tool to make temporary file handling in shells scripts safe and simple";
    mainProgram = "mktemp";
    homepage = "https://www.mktemp.org";
    license = licenses.isc;
    platforms = platforms.unix;
  };
}

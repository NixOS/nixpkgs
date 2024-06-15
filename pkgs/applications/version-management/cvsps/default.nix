{ lib, stdenv, fetchurl, fetchpatch, cvs, zlib }:

stdenv.mkDerivation rec {
  pname = "cvsps";
  version = "2.1";

  src = fetchurl {
    url = "mirror://debian/pool/main/c/cvsps/cvsps_${version}.orig.tar.gz";
    sha256 = "0nh7q7zcmagx0i63h6fqqkkq9i55k77myvb8h6jn2f266f5iklwi";
  };

  # Patches from https://sources.debian.net/src/cvsps/2.1-7/debian/patches
  patches =
    [ (fetchpatch {
        url = "https://sources.debian.net/data/main/c/cvsps/2.1-7/debian/patches/01_ignoretrunk.patch";
        sha256 = "1gzb97dw2a6bm0bmim7p7wvsn0r82y3a8n22ln6rbbkkd8vlnzcb";
      })

      (fetchpatch {
        url = "https://sources.debian.net/data/main/c/cvsps/2.1-7/debian/patches/02_dynamicbufferalloc.patch";
        sha256 = "0dm7azxnw0g9pdqkb3y4y2h047zgrclbh40av6c868wfp2j6l9sc";
      })

      (fetchpatch {
        url = "https://sources.debian.net/data/main/c/cvsps/2.1-7/debian/patches/03_diffoptstypo.patch";
        sha256 = "06n8652g7inpv8cgqir7ijq00qw1fr0v44m2pbmgx7ilmna2vrcw";
      })

      (fetchpatch {
        url = "https://sources.debian.net/data/main/c/cvsps/2.1-7/debian/patches/05-inet_addr_fix.patch";
        sha256 = "10w6px96dz8bb69asjzshvp787ccazmqnjsggqc4gwdal95q3cn7";
      })

      (fetchpatch {
        url = "https://sources.debian.net/data/main/c/cvsps/2.1-7/debian/patches/fix-makefile";
        sha256 = "0m92b55hgldwg6lwdaybbj0n3lw1b3wj2xkk1cz1ywq073bpf3jm";
      })

      (fetchpatch {
        url = "https://sources.debian.net/data/main/c/cvsps/2.1-7/debian/patches/fix-manpage";
        sha256 = "0gky14rhx82wv0gj8bkc74ki5xilhv5i3k1jc7khklr4lb6mmhpx";
      })
    ];

  buildInputs = [ cvs zlib ];

  installFlags = [ "prefix=$(out)" ];

  meta = {
    description = "Tool to generate CVS patch set information";
    longDescription = ''
      CVSps is a program for generating `patchset' information from a
      CVS repository.  A patchset in this case is defined as a set of
      changes made to a collection of files, and all committed at the
      same time (using a single "cvs commit" command).
    '';
    homepage = "http://www.cobite.com/cvsps/";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.unix;
    mainProgram = "cvsps";
  };
}

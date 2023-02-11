{ lib, stdenv, fetchurl, fetchpatch, zlib, htslib, perl, ncurses ? null }:

stdenv.mkDerivation rec {
  pname = "samtools";
  version = "1.13";

  src = fetchurl {
    url = "https://github.com/samtools/samtools/releases/download/${version}/${pname}-${version}.tar.bz2";
    sha256 = "sha256-YWyi4FHMgAmh6cAc/Yx8r4twkW3f9m87dpFAeUZfjGA=";
  };

  patches = [
    # Pull upstream patch for ncurses-6.3 support
    (fetchpatch {
      name = "ncurses-6.3.patch";
      url = "https://github.com/samtools/samtools/commit/396ef20eb0854d6b223c3223b60bb7efe42301f7.patch";
      sha256 = "sha256-p0l9ymXK9nqL2w8EytbW+qeaI7dD86IQgIVxacBj838=";
    })
  ];

  # tests require `bgzip` from the htslib package
  nativeCheckInputs = [ htslib ];

  nativeBuildInputs = [ perl ];

  buildInputs = [ zlib ncurses htslib ];

  preConfigure = lib.optional stdenv.hostPlatform.isStatic ''
    export LIBS="-lz -lbz2 -llzma"
  '';
  makeFlags = lib.optional stdenv.hostPlatform.isStatic "AR=${stdenv.cc.targetPrefix}ar";

  configureFlags = [ "--with-htslib=${htslib}" ]
    ++ lib.optional (ncurses == null) "--without-curses"
    ++ lib.optionals stdenv.hostPlatform.isStatic ["--without-curses" ]
    ;

  preCheck = ''
    patchShebangs test/
  '';

  enableParallelBuilding = true;

  doCheck = true;

  meta = with lib; {
    description = "Tools for manipulating SAM/BAM/CRAM format";
    license = licenses.mit;
    homepage = "http://www.htslib.org/";
    platforms = platforms.unix;
    maintainers = with maintainers; [ mimame unode ];
  };
}

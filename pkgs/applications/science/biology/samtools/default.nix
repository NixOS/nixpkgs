{ lib, stdenv, fetchurl, fetchpatch, zlib, htslib, perl, ncurses ? null }:

stdenv.mkDerivation rec {
  pname = "samtools";
  version = "1.18";

  src = fetchurl {
    url = "https://github.com/samtools/samtools/releases/download/${version}/${pname}-${version}.tar.bz2";
    sha256 = "sha256-1ob/piECO6YYIqKlC3DoXQsY55Nx3lrbB4KFGdP8BuE=";
  };

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

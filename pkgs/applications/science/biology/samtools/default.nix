{ lib, stdenv, fetchurl, zlib, htslib, perl, ncurses ? null }:

stdenv.mkDerivation rec {
  pname = "samtools";
  version = "1.19.2";

  src = fetchurl {
    url = "https://github.com/samtools/samtools/releases/download/${version}/${pname}-${version}.tar.bz2";
    hash = "sha256-cfYEmWaOTAjn10X7/yTBXMigl3q6sazV0rtBm9sGXpY=";
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

{ stdenv, fetchurl, perl, gperf, bison, groff
, pkgconfig, libXft, pcre
, libtomcrypt, libtommath, lz4 }:

stdenv.mkDerivation rec {
  pname = "bitkeeper";
  version = "7.3.1ce";

  src = fetchurl {
    url = "https://www.bitkeeper.org/downloads/${version}/bk-${version}.src.tar.gz";
    sha256 = "0l6jwvcg4s1q00vb01hdv58jgv03l8x5mhjl73cwgfiff80zx147";
  };

  hardeningDisable = [ "fortify" ];

  enableParallelBuilding = true;

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [
    perl gperf bison groff libXft
    pcre libtomcrypt libtommath lz4
  ];

  postPatch = ''
        substituteInPlace port/unix_platform.sh \
                --replace /bin/rm rm
        substituteInPlace ./undo.c \
                --replace /bin/cat cat
  '';

  sourceRoot = "bk-${version}/src";
  buildPhase = ''
    make -j6 V=1 p
    make image
  '';

  installPhase = ''
    ./utils/bk-* $out/bitkeeper
    mkdir -p $out/bin
    $out/bitkeeper/bk links $out/bin
    chmod g-w $out
  '';

  meta = {
    description     = "A distributed version control system";
    longDescription = ''
      BitKeeper is a fast, enterprise-ready, distributed SCM that
      scales up to very large projects and down to tiny ones.
    '';
    homepage    = "https://www.bitkeeper.org/";
    license     = stdenv.lib.licenses.asl20;
    platforms   = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ wscott thoughtpolice ];
    broken      = true; # seems to fail on recent glibc versions
  };
}

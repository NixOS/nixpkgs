{ stdenv, fetchurl, perl, gperf, bison, groff
, pkgconfig, libXft, fontconfig, pcre
, libtomcrypt, libtommath, lz4, zlib }:

stdenv.mkDerivation rec {
  name = "bitkeeper-${version}";
  version = "7.3ce";

  src = fetchurl {
    url = "https://www.bitkeeper.org/downloads/${version}/bk-${version}.tar.gz";
    sha256 = "0lk4vydpq5bi52m81h327gvzdzybf8kkak7yjwmpj6kg1jn9blaz";
  };

  hardeningDisable = [ "fortify" ];

  enableParallelBuilding = true;

  buildInputs = [
    perl gperf bison groff libXft pkgconfig
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
    homepage    = https://www.bitkeeper.org/;
    license     = stdenv.lib.licenses.asl20;
    platforms   = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ wscott thoughtpolice ];
  };
}

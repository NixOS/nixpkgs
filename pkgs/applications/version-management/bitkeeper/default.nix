{stdenv, fetchurl, perl, gperf, bison, groff,
 pkgconfig, libXft, fontconfig, pcre, libtomcrypt, libtommath, lz4, zlib}:

stdenv.mkDerivation rec {
  version = "7.3ce";
  name = "bitkeeper-${version}";
  enableParallelBuilding = true;
  src = fetchurl {
    url = "https://www.bitkeeper.org/downloads/${version}/bk-${version}.tar.gz";
    sha256 = "13249636f4b5b39f1d64b9f6bf682ee2dce53db17cdd8aa4cd9019e65252cabb";
  };
  sourceRoot = "bk-${version}/src";

  buildInputs = [ perl gperf bison groff libXft pkgconfig
	      pcre libtomcrypt libtommath lz4];

  postPatch = ''
	substituteInPlace port/unix_platform.sh \
		--replace /bin/rm rm
	substituteInPlace ./undo.c \
		--replace /bin/cat cat
  '';

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
    description = "A distributed version control system";
    longDescription = ''
	BitKeeper is a fast, enterprise-ready, distributed SCM that scales up to very large projects and down to tiny ones.
    '';
    homepage = http://www.bitkeeper.org/;
    license = stdenv.lib.licenses.asl20;
    platforms = with stdenv.lib.platforms; all;
    maintainers = [
      stdenv.lib.maintainers.wscott
    ];
  };
}

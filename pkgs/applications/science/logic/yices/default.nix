{ stdenv, fetchurl }:

assert stdenv.isLinux;

let
  libPath = stdenv.lib.makeLibraryPath [ stdenv.cc.libc ];
in
stdenv.mkDerivation rec {
  name    = "yices-${version}";
  version = "2.2.1";

  src =
    if stdenv.system == "i686-linux"
    then fetchurl {
      url = "http://yices.csl.sri.com/cgi-bin/yices2-newdownload.cgi?file=yices-2.2.1-i686-pc-linux-gnu-static-gmp.tar.gz&accept=I+accept";
      name = "yices-${version}-i686.tar.gz";
      sha256 = "12jzk3kqlbqa5x6rl92cpzj7dch7gm7fnbj72wifvwgdj4zyhrra";
    }
    else fetchurl {
      url = "http://yices.csl.sri.com/cgi-bin/yices2-newdownload.cgi?file=yices-2.2.1-x86_64-unknown-linux-gnu-static-gmp.tar.gz&accept=I+accept";
      name = "yices-${version}-x86_64.tar.gz";
      sha256 = "0fpmihf6ykcg4qbsimkamgcwp4sl1xyxmz7q28ily91rd905ijaj";
    };

  buildPhase = false;
  installPhase = ''
    mkdir -p $out/bin $out/lib $out/include
    cd bin     && mv * $out/bin     && cd ..
    cd lib     && mv * $out/lib     && cd ..
    cd include && mv * $out/include && cd ..

    patchelf --set-rpath ${libPath} $out/lib/libyices.so.${version}
  '';

  meta = {
    description = "Yices is a high-performance theorem prover and SMT solver";
    homepage    = "http://yices.csl.sri.com";
    license     = stdenv.lib.licenses.unfreeRedistributable;
    platforms   = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.thoughtpolice ];
  };
}

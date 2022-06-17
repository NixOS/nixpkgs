{ lib, stdenv, fetchurl, ghostscript }:

stdenv.mkDerivation rec {
  pname = "hmetis";
  version = "1.5";

  src = fetchurl {
    url = "http://glaros.dtc.umn.edu/gkhome/fetch/sw/hmetis/hmetis-${version}-linux.tar.gz";
    sha256 = "e835a098c046e9c26cecb8addfea4d18ff25214e49585ffd87038e72819be7e1";
  };

  nativeBuildInputs = [ ghostscript ];

  binaryFiles = "hmetis khmetis shmetis";

  patchPhase = ''
    for binaryfile in $binaryFiles; do
      patchelf \
        --set-interpreter ${stdenv.cc.libc}/lib/ld-linux.so.2 \
        --set-rpath ${stdenv.cc.libc}/lib \
        $binaryfile
    done
  '';

  buildPhase = ''
    gs -sOutputFile=manual.pdf -sDEVICE=pdfwrite -SNOPAUSE -dBATCH manual.ps
  '';

  installPhase = ''
    mkdir -p $out/bin $out/share/doc/hmetis $out/lib
    mv $binaryFiles $out/bin
    mv manual.pdf $out/share/doc/hmetis
    mv libhmetis.a $out/lib
  '';

  meta = with lib; {
    description = "hMETIS is a set of programs for partitioning hypergraphs";
    homepage = "http://glaros.dtc.umn.edu/gkhome/metis/hmetis/overview";
    license = licenses.unfree;
    platforms = [ "i686-linux" "x86_64-linux" ];
  };
}

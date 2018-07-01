{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "hmetis-${version}";
  version = "1.5";

  src = fetchurl {
    url = "http://glaros.dtc.umn.edu/gkhome/fetch/sw/hmetis/hmetis-${version}-linux.tar.gz";
    sha256 = "e835a098c046e9c26cecb8addfea4d18ff25214e49585ffd87038e72819be7e1";
  };

  binaryFiles = "hmetis khmetis shmetis";

  patchPhase = ''
    for binaryfile in $binaryFiles; do 
      patchelf \
        --set-interpreter ${stdenv.glibc}/lib/ld-linux.so.2 \
        --set-rpath ${stdenv.glibc}/lib \
        $binaryfile
    done
  '';

  installPhase = ''
    mkdir -p $out/bin
    for binaryfile in $binaryFiles; do 
      cp $binaryfile $out/bin
    done
  '';

  meta = with stdenv.lib; {
    description = "hMETIS is a set of programs for partitioning hypergraphs";
    homepage = http://glaros.dtc.umn.edu/gkhome/metis/hmetis/overview;  
    license = licenses.unfree;
    platforms = [ "i686-linux" "x86_64-linux" ];
  };
}

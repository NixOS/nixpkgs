{ stdenv, fetchurl, patchelf }:

stdenv.mkDerivation rec {
  name = "hmetis-${version}-i686";
  version = "1.5";

  buildInputs = [ patchelf ];

  src = fetchurl {
    url = "http://glaros.dtc.umn.edu/gkhome/fetch/sw/hmetis/hmetis-${version}-linux.tar.gz";
    sha256 = "e835a098c046e9c26cecb8addfea4d18ff25214e49585ffd87038e72819be7e1";
  };

  installPhase = ''
    mkdir -p $out/bin
    for binaryfile in hmetis khmetis shmetis; do 
      cp $binaryfile $out/bin
      patchelf --set-interpreter ${stdenv.glibc}/lib/ld-linux.so.2 \
        --set-rpath ${stdenv.glibc}/lib $out/bin/$binaryfile
    done
  '';

  meta = with stdenv.lib; {
    description = "hMETIS is a set of programs for partitioning hypergraphs";
    homepage = http://glaros.dtc.umn.edu/gkhome/metis/hmetis/overview;  
    license = licenses.unfree;
    platforms = [ "i686-linux" "x86_64-linux" ];
  };
}

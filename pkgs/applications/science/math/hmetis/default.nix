{ stdenv, fetchurl, patchelf }:

stdenv.mkDerivation rec {
  name = "hmetis-${version}-i686";
  version = "1.5";

  buildInputs = [ patchelf ];

  hmetissrc = fetchurl {
    url = "http://glaros.dtc.umn.edu/gkhome/fetch/sw/hmetis/hmetis-${version}-linux.tar.gz";
    sha256 = "e835a098c046e9c26cecb8addfea4d18ff25214e49585ffd87038e72819be7e1";
  };
  src = [ hmetissrc ];

  doCheck = true;

  installPhase = ''
    mkdir -p $out/bin
    cp hmetis $out/bin/
    patchelf --set-interpreter ${stdenv.glibc}/lib/ld-linux.so.2 $out/bin/hmetis
    patchelf --set-rpath ${stdenv.glibc}/lib $out/bin/hmetis
    cp khmetis $out/bin/
    patchelf --set-interpreter ${stdenv.glibc}/lib/ld-linux.so.2 $out/bin/khmetis
    patchelf --set-rpath ${stdenv.glibc}/lib $out/bin/khmetis
    cp shmetis $out/bin/
    patchelf --set-interpreter ${stdenv.glibc}/lib/ld-linux.so.2 $out/bin/shmetis
    patchelf --set-rpath ${stdenv.glibc}/lib $out/bin/shmetis
  '';

  meta = with stdenv.lib; {
    description = "hMETIS is a set of programs for partitioning hypergraphs";
    homepage = http://glaros.dtc.umn.edu/gkhome/metis/hmetis/overview;  
    license = licenses.unfree;
    platforms = [ "i686-linux" "x86_64-linux" ];
  };
}

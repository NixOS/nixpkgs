{ stdenv, fetchurl, patchelf, makeWrapper, xorg, gcc }:

assert stdenv.isLinux;

stdenv.mkDerivation rec {
   name = "IPMIView-${version}";
   version = "20151223";

   src = fetchurl {
     url = "ftp://ftp.supermicro.com/utility/IPMIView/Linux/IPMIView_V2.11.0_bundleJRE_Linux_x64_${version}.tar.gz";
     sha256 = "1rv9j0id7i2ipm25n60bpfdm1gj44xg2aj8rnx4s6id3ln90q121";
   };

   buildInputs = [ patchelf makeWrapper ];

   buildPhase = with xorg; ''
     patchelf --set-rpath "${libX11}/lib:${libXext}/lib:${libXrender}/lib:${libXtst}/lib:${libXi}/lib" ./jre/lib/amd64/xawt/libmawt.so
     patchelf --set-rpath "${gcc.cc}/lib" ./libiKVM64.so
     patchelf --set-rpath "${libXcursor}/lib:${libX11}/lib:${libXext}/lib:${libXrender}/lib:${libXtst}/lib:${libXi}/lib" --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" ./jre/bin/javaws
     patchelf --set-rpath "${gcc.cc}/lib:$out/jre/lib/amd64/jli" --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" ./jre/bin/java
   '';

   installPhase = ''
     mkdir -p $out/bin
     cp -R . $out/
     echo "$out/jre/bin/java -jar $out/IPMIView20.jar" > $out/bin/IPMIView
     chmod +x $out/bin/IPMIView
   '';

   meta = with stdenv.lib; {
    license = licenses.unfree;
   };
  }


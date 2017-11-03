{ stdenv, fetchurl, patchelf, makeWrapper, xorg, gcc }:

assert stdenv.isLinux;

stdenv.mkDerivation rec {
   name = "IPMIView-${version}";
   version = "2.13.0";
   buildVersion = "170504";

   src = fetchurl {
    url = "ftp://ftp.supermicro.com/utility/IPMIView/Linux/IPMIView_${version}_build.${buildVersion}_bundleJRE_Linux_x64.tar.gz";
    sha256 = "1hfw5g6lxg3vqg0nc3g2sv2h6bn8za35bxxms0ri0sgb9v3xg1y6";
  };

   buildInputs = [ patchelf makeWrapper ];

   buildPhase = with xorg; ''
     patchelf --set-rpath "${stdenv.lib.makeLibraryPath [ libX11 libXext libXrender libXtst libXi ]}" ./jre/lib/amd64/xawt/libmawt.so
     patchelf --set-rpath "${gcc.cc}/lib" ./libiKVM64.so
     patchelf --set-rpath "${stdenv.lib.makeLibraryPath [ libXcursor libX11 libXext libXrender libXtst libXi ]}" --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" ./jre/bin/javaws
     patchelf --set-rpath "${gcc.cc}/lib:$out/jre/lib/amd64/jli" --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" ./jre/bin/java
   '';

   installPhase = ''
     mkdir -p $out/bin
     cp -R . $out/
     makeWrapper $out/jre/bin/java $out/bin/IPMIView \
       --prefix PATH : "$out/jre/bin" \
       --add-flags "-jar $out/IPMIView20.jar"
   '';

   meta = with stdenv.lib; {
    license = licenses.unfree;
   };
  }

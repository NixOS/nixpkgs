{fetchurl, stdenv, unzip}:

let {
  body =
    stdenv.mkDerivation {
      name = "eclipse-sdk-3.0.1";
      builder = ./builder.sh;
      src = bindist;
      inherit unzip;
   };

  bindist = 
    fetchurl {
      url = http://catamaran.labs.cs.uu.nl/dist/tarballs/eclipse-SDK-3.0.1-linux-gtk.zip;
      md5 = "d0f743c972adf13e71a43b2dc6c9c55b";
    };
}

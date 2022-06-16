{stdenv, gdk-pixbuf}:
stdenv.mkDerivation {
  name = "mock-gdk-pixbuf-module";
  outputs = ["out" "bin"];
  dontUnpack = true;
  buildPhase = ''
    mkdir -p $bin
    mkdir -p $out/$(dirname ${gdk-pixbuf.cacheFile})
    touch $out/${gdk-pixbuf.cacheFile}
  '';
  dontInstall = true;
  dontFixup = true;
}
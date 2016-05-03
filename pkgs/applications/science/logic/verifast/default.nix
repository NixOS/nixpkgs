{ stdenv, fetchurl, gtk, gdk_pixbuf, atk, pango, glib, cairo, freetype
, fontconfig, libxml2, gnome2 }:

assert stdenv.isLinux;

let
  libPath = stdenv.lib.makeLibraryPath
    [ stdenv.cc.libc stdenv.cc.cc gtk gdk_pixbuf atk pango glib cairo
      freetype fontconfig libxml2 gnome2.gtksourceview
    ] + ":${stdenv.cc.cc.lib}/lib64";

  patchExe = x: ''
    patchelf --interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      --set-rpath ${libPath} ${x}
  '';
in
stdenv.mkDerivation rec {
  name    = "verifast-${version}";
  version = "14.5";

  src = fetchurl {
    url    = "http://people.cs.kuleuven.be/~bart.jacobs/verifast/${name}-x64.tar.gz";
    sha256 = "03y1s6s2j9vqgiad0vbxriipsypxaylxxd3q36n9rvrc3lf9xra9";
  };

  dontStrip = true;
  phases = "unpackPhase installPhase";
  installPhase = ''
    mkdir -p $out/bin
    cp -R bin $out/libexec

    ${patchExe "$out/libexec/verifast-core"}
    ${patchExe "$out/libexec/vfide-core"}
    ln -s $out/libexec/verifast-core $out/bin/verifast
    ln -s $out/libexec/vfide-core    $out/bin/vfide
  '';

  meta = {
    description = "Verification for C and Java programs via separation logic";
    homepage    = "http://people.cs.kuleuven.be/~bart.jacobs/verifast/";
    license     = stdenv.lib.licenses.msrla;
    platforms   = [ "x86_64-linux" ];
    maintainers = [ stdenv.lib.maintainers.thoughtpolice ];
  };
}

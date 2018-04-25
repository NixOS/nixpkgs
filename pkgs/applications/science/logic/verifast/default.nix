{ stdenv, fetchurl, gtk2, gdk_pixbuf, atk, pango, glib, cairo, freetype
, fontconfig, libxml2, gnome2 }:

assert stdenv.isLinux;
let

  libPath = stdenv.lib.makeLibraryPath
    [ stdenv.cc.libc stdenv.cc.cc gtk2 gdk_pixbuf atk pango glib cairo
      freetype fontconfig libxml2 gnome2.gtksourceview
    ] + ":${stdenv.cc.cc.lib}/lib64:$out/libexec";

  patchExe = x: ''
    patchelf --interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      --set-rpath ${libPath} ${x}
  '';

  patchLib = x: ''
    patchelf --set-rpath ${libPath} ${x}
  '';

in
stdenv.mkDerivation rec {
  name    = "verifast-${version}";
  version = "18.02";

  src = fetchurl {
    url    = "https://github.com/verifast/verifast/releases/download/${version}/${name}-linux.tar.gz";
    sha256 = "19050be23b6d5e471690421fee59f84c58b29e38379fb86b8f3713a206a4423e";
  };

  dontStrip = true;
  phases = "unpackPhase installPhase";
  installPhase = ''
    mkdir -p $out/bin
    cp -R bin $out/libexec

    ${patchExe "$out/libexec/verifast"}
    ${patchExe "$out/libexec/vfide"}
    ${patchLib "$out/libexec/libz3.so"}
    ln -s $out/libexec/verifast $out/bin/verifast
    ln -s $out/libexec/vfide    $out/bin/vfide
  '';

  meta = {
    description = "Verification for C and Java programs via separation logic";
    homepage    = "http://people.cs.kuleuven.be/~bart.jacobs/verifast/";
    license     = stdenv.lib.licenses.msrla;
    platforms   = [ "x86_64-linux" ];
    maintainers = [ stdenv.lib.maintainers.thoughtpolice ];
  };
}

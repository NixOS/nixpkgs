{ stdenv, fetchurl, gtk2, gdk-pixbuf, atk, pango, glib, cairo, freetype
, fontconfig, libxml2, gnome2 }:

let

  libPath = stdenv.lib.makeLibraryPath
    [ stdenv.cc.libc stdenv.cc.cc gtk2 gdk-pixbuf atk pango glib cairo
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
  pname = "verifast";
  version = "19.12";

  src = fetchurl {
    url    = "https://github.com/verifast/verifast/releases/download/${version}/${pname}-${version}-linux.tar.gz";
    sha256 = "169kshjq4cf4i9v92azv0xaflrnik5686w7fwcgdhd6qkbzflzl6";
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

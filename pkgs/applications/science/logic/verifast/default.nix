{ stdenv, fetchurl, gtk, gdk_pixbuf, atk, pango, glib, cairo, freetype
, fontconfig, libxml2, gnome2 }:

let
  libPath = stdenv.lib.makeLibraryPath
    [ stdenv.gcc.libc stdenv.gcc.gcc gtk gdk_pixbuf atk pango glib cairo
      freetype fontconfig libxml2 gnome2.gtksourceview
    ];

  patchLib = x: extra: "patchelf --set-rpath ${libPath}:${extra} ${x}";
  patchExe = x: extra: ''
    patchelf --interpreter "$(cat $NIX_GCC/nix-support/dynamic-linker)" \
      --set-rpath ${libPath}:${extra} ${x}
  '';
in
stdenv.mkDerivation rec {
  name    = "verifast-${version}";
  version = "13.11.14";

  src = fetchurl {
    url    = "http://people.cs.kuleuven.be/~bart.jacobs/verifast/verifast-13.11.14.tar.gz";
    sha256 = "1ahay7achjsfz59d3b6vl1v91gr5j34vb494isqw3fsw5l8jd9p7";
  };

  dontStrip = true;
  installPhase = ''
    mkdir -p $out/bin
    cp -R bin $out/libexec

    ${patchLib "$out/libexec/libz3-gmp.so"  "$out/libexec"}
    ${patchExe "$out/libexec/vfide-core"    "$out/libexec"}
    ${patchExe "$out/libexec/verifast-core" "$out/libexec"}

    ln -s $out/libexec/verifast-core $out/bin/verifast
    ln -s $out/libexec/vfide-core    $out/bin/vfide
  '';

  phases = "unpackPhase installPhase";

  meta = {
    description = "Verification for C and Java programs via separation logic";
    homepage    = "http://people.cs.kuleuven.be/~bart.jacobs/verifast/";
    license     = stdenv.lib.licenses.msrla;
    platforms   = [ "i686-linux" ];
    maintainers = [ stdenv.lib.maintainers.thoughtpolice ];
  };
}

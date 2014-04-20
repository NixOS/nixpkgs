{ fetchurl, stdenv, glib, xlibs, cairo, gtk, pango}:
let
  libPath = stdenv.lib.makeLibraryPath [glib xlibs.libX11 gtk cairo pango];
in
assert stdenv.system == "i686-linux" || stdenv.system == "x86_64-linux";

stdenv.mkDerivation rec {
  name = "sublimetext3-3.0.59";
  src = 
    if stdenv.system == "i686-linux" then
      fetchurl {
        name = "sublimetext-3.0.59.tar.bz2";
        url = http://c758482.r82.cf2.rackcdn.com/sublime_text_3_build_3059_x32.tar.bz2;
        sha256 = "5ee7b42b5db057108e97b86fd408124fc3f7b56662b2851f59d91f8f0c288088";
      }
    else
      fetchurl {
        name = "sublimetext-3.0.59.tar.bz2";
        url = http://c758482.r82.cf2.rackcdn.com/sublime_text_3_build_3059_x64.tar.bz2;
        sha256 = "da3039687664d33a734cea0151b2291ece9c7f35e5b73df5b2b5eac28a20b972";
      };
  buildCommand = ''
    tar xvf ${src}
    mkdir -p $out/bin
    mv sublime_text_3 $out/sublime
    ln -s $out/sublime/sublime_text $out/bin/sublime
    ln -s $out/sublime/sublime_text $out/bin/sublime3

    echo ${libPath}
    patchelf \
      --interpreter "$(cat $NIX_GCC/nix-support/dynamic-linker)" \
      --set-rpath ${libPath}:${stdenv.gcc.gcc}/lib${stdenv.lib.optionalString stdenv.is64bit "64"} \
      $out/sublime/sublime_text
  '';

  meta = {
    description = "Sophisticated text editor for code, markup and prose";
    license = "unfree";
  };
}

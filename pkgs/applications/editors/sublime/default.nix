{ fetchurl, stdenv, glib, xlibs, cairo, gtk}:
let
  libPath = stdenv.lib.makeLibraryPath [glib xlibs.libX11 gtk cairo];
in
assert stdenv.system == "i686-linux" || stdenv.system == "x86_64-linux";

stdenv.mkDerivation rec {
  name = "sublimetext-2.0.2";
  src = 
    if stdenv.system == "i686-linux" then
      fetchurl {
        name = "sublimetext-2.0.2.tar.bz2";
        url = http://c758482.r82.cf2.rackcdn.com/Sublime%20Text%202.0.2.tar.bz2;
        sha256 = "026g5mppk28lzzzn9ibykcqkrd5msfmg0sc0z8w8jd7v3h28wcq7";
      }
    else
      fetchurl {
        name = "sublimetext-2.0.2.tar.bz2";
        url = http://c758482.r82.cf2.rackcdn.com/Sublime%20Text%202.0.2%20x64.tar.bz2;
        sha256 = "115b71nbv9mv8cz6bkjwpbdf2ywnjc1zy2d3080f6ck4sqqfvfh1";
      };
  buildCommand = ''
    tar xvf ${src}
    mkdir -p $out/bin
    mv Sublime* $out/sublime
    ln -s $out/sublime/sublime_text $out/bin/sublime

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

{ fetchurl, stdenv, glib, xlibs, cairo, gtk}:
let
  libPath = stdenv.lib.makeLibraryPath [glib xlibs.libX11 gtk cairo];
in
assert stdenv.system == "i686-linux" || stdenv.system == "x86_64-linux";

stdenv.mkDerivation rec {
  name = "sublimetext-2.0.1";
  src = 
    if stdenv.system == "i686-linux" then
      fetchurl {
        name = "sublimetext-2.0.1.tar.bz2";
        url = http://c758482.r82.cf2.rackcdn.com/Sublime%20Text%202.0.1.tar.bz2;
        sha256 = "1x6vmlfn5mdbf23nyfr7dhhi6y60lnpcmqj59svl3bzvayijsxaf";
      }
    else
      fetchurl {
        name = "sublimetext-2.0.1.tar.bz2";
        url = http://c758482.r82.cf2.rackcdn.com/Sublime%20Text%202.0.1%20x64.tar.bz2;
        sha256 = "0174dnp9zika5as25mcls5y0qzhh8mnc5ajxsxz7qjrk4lrzk3c5";
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
    description = "Sublime Text is a sophisticated text editor for code, markup and prose.";
    license = "unfree";
  };
}

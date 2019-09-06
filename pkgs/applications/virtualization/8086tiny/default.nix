{ stdenv, fetchurl
, localBios ? true, nasm ? null
, sdlSupport ? true, SDL ? null }:

assert sdlSupport -> (SDL != null);

stdenv.mkDerivation {

  pname = "8086tiny";
  version = "1.25";

  src = fetchurl {
    url ="http://www.megalith.co.uk/8086tiny/downloads/8086tiny_125.tar.bz2";
    sha256 = "0kmq4iiwhi2grjwq43ljjk1b1f1v1x9gzrgrgq2fzfsj7m7s6ris";
  };

  buildInputs = with stdenv.lib;
  optionals localBios [ nasm ]
  ++  optionals sdlSupport [ SDL ];
  
  bios = localBios;
  
  builder = ./builder.sh;

  meta = {
    description = "An open-source 8086 emulator";
    longDescription = ''
    8086tiny is a tiny, open-source (MIT), portable (little-endian hosts) Intel PC emulator, powerful enough to run DOS, Windows 3.0, Excel, MS Flight Simulator, AutoCAD, Lotus 1-2-3, and similar applications. 8086tiny emulates a "late 80's era" PC XT-type machine.

    8086tiny is based on an IOCCC 2013 winning entry. In fact that is the "unobfuscated" version :)
    '';
    homepage = http://www.megalith.co.uk/8086tiny/index.html;
    license = stdenv.lib.licenses.mit;
    maintainers = [ stdenv.lib.maintainers.AndersonTorres ];
    platforms = stdenv.lib.platforms.linux;
  };
}

# TODO: add support for a locally made BIOS

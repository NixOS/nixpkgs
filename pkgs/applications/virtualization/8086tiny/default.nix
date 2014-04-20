{ stdenv, fetchurl
, localBios ? false, nasm ? null
, sdlSupport ? true, SDL ? null
}:


assert sdlSupport -> (SDL != null);


stdenv.mkDerivation rec {

  name = "8086tiny-${version}";
  version = "1.20";

  src = fetchurl {
    url ="http://www.megalith.co.uk/8086tiny/downloads/8086tiny_120.tar.bz2";
    sha256 = "0yapnr8wvlx7h1q1w98yfy2vsbf0rlp4wd99r3xb0b7l70b36mpw";
  };

  buildInputs = with stdenv.lib;
  optionals localBios [ nasm ]
  ++  optionals sdlSupport [ SDL ];

  builder = ./builder.sh;

  meta = {
    description = "An open-source 8086 emulator";
    longDescription = ''
    8086tiny is a tiny, open source (MIT), portable (little-endian hosts) Intel PC emulator, powerful enough to run DOS, Windows 3.0, Excel, MS Flight Simulator, AutoCAD, Lotus 1-2-3, and similar applications. 8086tiny emulates a "late 80's era" PC XT-type machine.

    8086tiny is based on an IOCCC 2013 winning entry. In fact that is the "unobfuscated" version :)
    '';
    homepage = http://www.megalith.co.uk/8086tiny/index.html;
    license = stdenv.lib.licenses.mit;
    maintainers = [ stdenv.lib.maintainers.AndersonTorres ];
    platforms = stdenv.lib.platforms.linux;
  };
}

# TODO: add support for a locally made BIOS

{ stdenv, fetchFromGitHub
, localBios ? true, nasm ? null
, sdlSupport ? true, SDL ? null }:

assert sdlSupport -> (SDL != null);

stdenv.mkDerivation rec {

  pname = "8086tiny";
  version = "1.25";

  src = fetchFromGitHub {
    owner = "adriancable";
    repo = pname;
    rev = "c79ca2a34d96931d55ef724c815b289d0767ae3a";
    sha256 = "00aydg8f28sgy8l3rd2a7jvp56lx3b63hhak43p7g7vjdikv495w";
  };

  buildInputs = with stdenv.lib;
  optionals localBios [ nasm ]
  ++  optionals sdlSupport [ SDL ];
  
  bios = localBios;
  
  builder = ./builder.sh;

  meta = with stdenv.lib; {
    description = "An open-source small 8086 emulator";
    longDescription = ''
      8086tiny is a tiny, open-source (MIT), portable (little-endian hosts)
      Intel PC emulator, powerful enough to run DOS, Windows 3.0, Excel, MS
      Flight Simulator, AutoCAD, Lotus 1-2-3, and similar applications. 8086tiny
      emulates a "late 80's era" PC XT-type machine.

      8086tiny is based on an IOCCC 2013 winning entry. In fact that is the
      "unobfuscated" version :)
    '';
    homepage = "https://github.com/adriancable/8086tiny";
    license = licenses.mit;
    maintainers = [ maintainers.AndersonTorres ];
    platforms = platforms.linux;
  };
}

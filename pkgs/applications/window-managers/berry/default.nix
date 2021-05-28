{ stdenv, fetchFromGitHub
, libX11, libXft, libXinerama, fontconfig, freetype }:

stdenv.mkDerivation rec {
  pname = "berry";
  version = "0.1.5";

  src = fetchFromGitHub {
    owner = "JLErvin";
    repo = "berry";
    rev = version;
    sha256 = "1wxbjzpwqb9x7vd7kb095fiqj271rki980dnwcxjxpqlmmrmjzyl";
  };

  buildInputs = [ libX11 libXft libXinerama fontconfig freetype ];

  preBuild = ''
    makeFlagsArray+=( PREFIX="${placeholder "out"}"
                      X11INC="${libX11.dev}/include"
                      X11LIB="${libX11}/lib"
                      XINERAMALIBS="-lXinerama"
                      XINERAMAFLAGS="-DXINERAMA"
                      FREETYPELIBS="-lfontconfig -lXft"
                      FREETYPEINC="${freetype.dev}/include/freetype2" )
  '';

  meta = with stdenv.lib; {
    description = "A healthy, bite-sized window manager";
    longDescription = ''
      berry is a healthy, bite-sized window manager written in C for unix
      systems. Its main features include:

      - Controlled via a powerful command-line client, allowing users to control
        windows via a hotkey daemon such as sxhkd or expand functionality via
        shell scripts.
      - Small, hackable source code.
      - Extensible themeing options with double borders, title bars, and window
        text.
      - Intuitively place new windows in unoccupied spaces.
      - Virtual desktops.
    '';
    homepage = "https://berrywm.org/";
    license = licenses.mit;
    maintainers = [ maintainers.AndersonTorres ];
    platforms = platforms.linux;
  };
}

{ lib, stdenv
, fetchFromGitHub
, libX11
, libXext
, libXft
, libXinerama
, fontconfig
, freetype
}:

stdenv.mkDerivation rec {
  pname = "berry";
  version = "0.1.7";

  src = fetchFromGitHub {
    owner = "JLErvin";
    repo = pname;
    rev = version;
    sha256 = "sha256-2kFVOE5l1KQvDb5KDL7y0p4M7awJLrxJF871cyc0YZ8=";
  };

  buildInputs =[
    libX11
    libXext
    libXft
    libXinerama
    fontconfig
    freetype
  ];

  preBuild = ''
    makeFlagsArray+=( PREFIX="${placeholder "out"}"
                      X11INC="${libX11.dev}/include"
                      X11LIB="${libX11}/lib"
                      XINERAMALIBS="-lXinerama"
                      XINERAMAFLAGS="-DXINERAMA"
                      FREETYPELIBS="-lfontconfig -lXft"
                      FREETYPEINC="${freetype.dev}/include/freetype2" )
  '';

  meta = with lib; {
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

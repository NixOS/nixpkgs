{ stdenv, fetchFromGitHub, python3, libX11, libXrandr }:

stdenv.mkDerivation rec {
  pname = "blugon";
  version = "1.12.0";

  src = fetchFromGitHub {
    owner = "jumper149";
    repo = pname;
    rev = version;
    sha256 = "0vdhq8v011awhpkccbcmigj9c46widyzh0m5knafapanai3kv7ii";
  };

  buildInputs = [ python3 libX11 libXrandr ];

  makeFlags = [ "PREFIX=$(out)" ];

  meta = with stdenv.lib; {
    description = "Simple and configurable Blue Light Filter for X";
    longDescription = ''
      blugon is a simple and fast Blue Light Filter, that is highly configurable and provides a command line interface.
      The program can be run just once or as a daemon (manually or via systemd).
      There are several different backends available.
      blugon calculates the screen color from your local time and configuration.
    '';
    license = licenses.asl20;
    homepage = "https://github.com/jumper149/blugon";
    platforms = platforms.unix;
    maintainers = with maintainers; [ jumper149 ];
  };
}

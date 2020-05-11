{ stdenv, fetchFromGitHub
, autoreconfHook
, alsaLib, python, SDL }:

stdenv.mkDerivation rec {
  pname = "schismtracker";
  version = "20190805";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = version;
    sha256 = "0qqps20vvn3rgpg8174bjrrm38gqcci2z5z4c1r1vhbccclahgsd";
  };

  configureFlags = [ "--enable-dependency-tracking" ];

  nativeBuildInputs = [ autoreconfHook python ];

  buildInputs = [ alsaLib SDL ];

  meta = with stdenv.lib; {
    description = "Music tracker application, free reimplementation of Impulse Tracker";
    homepage = "http://schismtracker.org/";
    license = licenses.gpl2;
    platforms = [ "x86_64-linux" "i686-linux" ];
    maintainers = with maintainers; [ ftrvxmtrx ];
  };
}

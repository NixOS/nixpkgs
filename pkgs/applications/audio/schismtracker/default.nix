{ stdenv, fetchFromGitHub
, autoreconfHook
, alsaLib, python, SDL }:

stdenv.mkDerivation rec {
  pname = "schismtracker";
  version = "20200412";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = version;
    sha256 = "1n6cgjiw3vkv7a1h1nki5syyjxjb6icknr9s049w2jrag10bxssn";
  };

  configureFlags = [ "--enable-dependency-tracking" ];

  nativeBuildInputs = [ autoreconfHook python ];

  buildInputs = [ SDL ] ++ stdenv.lib.optional stdenv.isLinux alsaLib;

  meta = with stdenv.lib; {
    description = "Music tracker application, free reimplementation of Impulse Tracker";
    homepage = "http://schismtracker.org/";
    license = licenses.gpl2;
    platforms = [ "x86_64-linux" "i686-linux" "x86_64-darwin" ];
    maintainers = with maintainers; [ ftrvxmtrx ];
  };
}

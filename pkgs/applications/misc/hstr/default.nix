{ stdenv, fetchFromGitHub, readline, ncurses
, autoreconfHook, pkgconfig, gettext }:

stdenv.mkDerivation rec {
  pname = "hstr";
  version = "2.3";

  src = fetchFromGitHub {
    owner  = "dvorka";
    repo   = "hstr";
    rev    = version;
    sha256 = "1chmfdi1dwg3sarzd01nqa82g65q7wdr6hrnj96l75vikwsg986y";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig ];
  buildInputs = [ readline ncurses gettext ];

  configureFlags = [ "--prefix=$(out)" ];

  meta = {
    homepage = "https://github.com/dvorka/hstr";
    description = "Shell history suggest box - easily view, navigate, search and use your command history";
    license = stdenv.lib.licenses.asl20;
    maintainers = [ stdenv.lib.maintainers.matthiasbeyer ];
    platforms = with stdenv.lib.platforms; linux ++ darwin;
  };

}

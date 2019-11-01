{ stdenv, fetchFromGitHub, readline, ncurses
, autoreconfHook, pkgconfig, gettext }:

stdenv.mkDerivation rec {
  pname = "hstr";
  version = "2.0";

  src = fetchFromGitHub {
    owner  = "dvorka";
    repo   = "hstr";
    rev    = version;
    sha256 = "1y9vsfbg07gbic0daqy569d9pb9i1d07fym3q7a0a99hbng85s20";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig ];
  buildInputs = [ readline ncurses gettext ];

  configurePhase = ''
    autoreconf -fvi
    ./configure
  '';

  installPhase = ''
    mkdir -p $out/bin/
    mv src/hstr $out/bin/
  '';

  meta = {
    homepage = https://github.com/dvorka/hstr;
    description = "Shell history suggest box - easily view, navigate, search and use your command history";
    license = stdenv.lib.licenses.asl20;
    maintainers = [ stdenv.lib.maintainers.matthiasbeyer ];
    platforms = with stdenv.lib.platforms; linux; # Cannot test others
  };

}

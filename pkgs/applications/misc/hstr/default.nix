{ stdenv, fetchFromGitHub, readline, ncurses
, autoreconfHook, pkgconfig, gettext }:

stdenv.mkDerivation rec {
  pname = "hstr";
  version = "2.2";

  src = fetchFromGitHub {
    owner  = "dvorka";
    repo   = "hstr";
    rev    = version;
    sha256 = "07fkilqlkpygvf9kvxyvl58g3lfq0bwwdp3wczy4hk8qlbhmgihn";
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

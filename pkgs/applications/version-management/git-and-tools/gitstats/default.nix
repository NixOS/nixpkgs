{ lib, stdenv, fetchFromGitHub, perl, python2, gnuplot, coreutils, gnugrep }:

stdenv.mkDerivation rec {
  pname = "gitstats";
  version = "2016-01-08";

  # upstream does not make releases
  src = fetchFromGitHub {
    owner = "hoxu";
    repo = "gitstats";
    rev = "55c5c285558c410bb35ebf421245d320ab9ee9fa";
    sha256 = "sha256-qUQB3aCRbPkbMoMf39kPQ0vil8RjXL8RqjdTryfkzK0=";
  };

  nativeBuildInputs = [ perl ];

  buildInputs = [ python2 ];

  strictDeps = true;

  postPatch = ''
    sed -e "s|gnuplot_cmd = .*|gnuplot_cmd = '${gnuplot}/bin/gnuplot'|" \
        -e "s|\<wc\>|${coreutils}/bin/wc|g" \
        -e "s|\<grep\>|${gnugrep}/bin/grep|g" \
        -i gitstats
  '';

  buildPhase = ''
    make man VERSION="${version}"
  '';

  installPhase = ''
    make install PREFIX="$out" VERSION="${version}"
    install -Dm644 doc/gitstats.1 "$out"/share/man/man1/gitstats.1
  '';

  meta = with lib; {
    homepage = "http://gitstats.sourceforge.net/";
    description = "Git history statistics generator";
    license = licenses.gpl2Plus;
    platforms = platforms.all;
    maintainers = [ maintainers.bjornfor ];
  };
}

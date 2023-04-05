{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, installShellFiles
, perl
, python3
, gnuplot
, coreutils
, gnugrep
}:

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

  patches = [
    # make gitstats compatible with python3
    # https://github.com/hoxu/gitstats/pull/105
    (fetchpatch {
      name = "convert-gitstats-to-use-python3.patch";
      url = "https://github.com/hoxu/gitstats/commit/ca415668ce6b739ca9fefba6acd29c63b89f4211.patch";
      hash = "sha256-sgjoj8eQ5CxQBffmhqymsmXb8peuaSbfFoWciLK3LOo=";
    })
  ];

  nativeBuildInputs = [ installShellFiles perl ];

  buildInputs = [ python3 ];

  strictDeps = true;

  postPatch = ''
    sed -e "s|gnuplot_cmd = .*|gnuplot_cmd = '${gnuplot}/bin/gnuplot'|" \
        -e "s|\<wc\>|${coreutils}/bin/wc|g" \
        -e "s|\<grep\>|${gnugrep}/bin/grep|g" \
        -i gitstats
  '';

  makeFlags = [
    "PREFIX=$(out)"
    "VERSION=${version}"
  ];

  buildFlags = [ "man" ];

  postInstall = ''
    installManPage doc/gitstats.1
  '';

  meta = with lib; {
    homepage = "https://gitstats.sourceforge.net/";
    description = "Git history statistics generator";
    license = licenses.gpl2Plus;
    platforms = platforms.all;
    maintainers = with maintainers; [ bjornfor ];
  };
}

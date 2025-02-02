{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "fbmark";
  version = "0.3";

  src = fetchFromGitHub {
    owner = "caramelli";
    repo = pname;
    rev = "v${version}";
    sha256 = "0n2czl2sy1k6r5ri0hp7jgq84xcwrx4x43bqvw1b4na99mqhyahn";
  };

  makeFlags = [ "PREFIX=$(out)" ];

  meta = with lib; {
    description = "Linux Framebuffer Benchmark";
    homepage = "https://github.com/caramelli/fbmark";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ davidak ];
    platforms = platforms.linux;
  };
}

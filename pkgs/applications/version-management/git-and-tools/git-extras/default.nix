{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "git-extras-${version}";
  version = "4.2.0";

  src = fetchurl {
    url = "https://github.com/tj/git-extras/archive/${version}.tar.gz";
    sha256 = "0pr2vf5rajkwjm45zvnwkc13kvk3kyr18axxvmm8drsqdkr8lrjk";
  };

  phases = [ "unpackPhase" "installPhase" ];

  makeFlags = "DESTDIR=$(out) PREFIX=";

  meta = with stdenv.lib; {
    homepage = https://github.com/tj/git-extras;
    description = "GIT utilities -- repo summary, repl, changelog population, author commit percentages and more";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = [ maintainers.spwhitt maintainers.cko ];
  };
}

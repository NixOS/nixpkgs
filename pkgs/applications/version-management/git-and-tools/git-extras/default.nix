{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "git-extras-${version}";
  version = "2.2.0";

  src = fetchurl {
    url = "https://github.com/tj/git-extras/archive/${version}.tar.gz";
    sha256 = "0qwgaj0r9lsmwricpnma9rm7llfrcqarcfk5iq3ilxkns8a334va";
  };

  phases = [ "unpackPhase" "installPhase" ];

  makeFlags = "DESTDIR=$(out) PREFIX=";

  meta = with stdenv.lib; {
    homepage = https://github.com/tj/git-extras;
    description = "GIT utilities -- repo summary, repl, changelog population, author commit percentages and more";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = [ maintainers.spwhitt ];
  };
}

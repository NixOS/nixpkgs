{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "git-extras-${version}";
  version = "4.1.0";

  src = fetchurl {
    url = "https://github.com/tj/git-extras/archive/${version}.tar.gz";
    sha256 = "d4c028e2fe78abde8f3e640b70f431318fb28d82894dde22772efe8ba3563f85";
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

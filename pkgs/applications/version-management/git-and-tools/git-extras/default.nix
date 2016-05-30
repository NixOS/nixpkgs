{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "git-extras-${version}";
  version = "4.1.0";

  src = fetchurl {
    url = "https://github.com/tj/git-extras/archive/${version}.tar.gz";
    sha256 = "119zasiqpziffwidwkc9ha6v53ri67s702v47s7xxavqzvi2ih6l";
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

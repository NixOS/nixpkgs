{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "git-extras-${version}";
  version = "4.5.0";

  src = fetchurl {
    url = "https://github.com/tj/git-extras/archive/${version}.tar.gz";
    sha256 = "059680bvblbhrlkybg1yisr5zq62pir1rnaxz5izhfsw2ng9s2fb";
  };

  dontBuild = true;

  installFlags = [ "DESTDIR=$(out) PREFIX=" ];

  meta = with stdenv.lib; {
    homepage = https://github.com/tj/git-extras;
    description = "GIT utilities -- repo summary, repl, changelog population, author commit percentages and more";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = [ maintainers.spwhitt maintainers.cko ];
  };
}

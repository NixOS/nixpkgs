{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "git-extras-${version}";
  version = "4.4.0";

  src = fetchurl {
    url = "https://github.com/tj/git-extras/archive/${version}.tar.gz";
    sha256 = "0vb8syyr5nbvmkj5g4rb1p8rqxb2hyl25gbyf4rd0b972d7iihhn";
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

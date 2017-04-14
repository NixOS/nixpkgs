{ stdenv, fetchFromGitHub, pythonPackages }:

stdenv.mkDerivation rec {
  name = "git-imerge-${version}";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "mhagger";
    repo = "git-imerge";
    rev = "v${version}";
    sha256 = "1ylzxmbjfrzzxmcrbqzy1wv21npqj1r6cgl77a9n2zvsrz8zdb74";
  };

  buildInputs = [ pythonPackages.python pythonPackages.wrapPython ];

  makeFlags = "PREFIX= DESTDIR=$(out)" ; 
 
  meta = with stdenv.lib; {
    homepage = https://github.com/mhagger/git-imerge;
    description = "Perform a merge between two branches incrementally";
    license = licenses.gpl2;
    platforms = platforms.all;
    maintainers = [ maintainers.spwhitt ];
  };
}

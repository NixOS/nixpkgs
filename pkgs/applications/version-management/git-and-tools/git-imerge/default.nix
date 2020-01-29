{ stdenv, fetchFromGitHub, pythonPackages }:

stdenv.mkDerivation rec {
  pname = "git-imerge";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "mhagger";
    repo = "git-imerge";
    rev = "v${version}";
    sha256 = "0vi1w3f0yk4gqhxj2hzqafqq28rihyhyfnp8x7xzib96j2si14a4";
  };

  buildInputs = [ pythonPackages.python pythonPackages.wrapPython ];

  makeFlags = [ "PREFIX=" "DESTDIR=$(out)" ] ; 
 
  meta = with stdenv.lib; {
    homepage = https://github.com/mhagger/git-imerge;
    description = "Perform a merge between two branches incrementally";
    license = licenses.gpl2;
    platforms = platforms.all;
    maintainers = [ maintainers.spwhitt ];
  };
}

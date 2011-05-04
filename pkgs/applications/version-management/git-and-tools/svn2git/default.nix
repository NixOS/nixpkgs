{ stdenv, fetchgit, qt47, subversion, apr}:

stdenv.mkDerivation rec {
  name = "svn2git";

  src = fetchgit {
    url = http://git.gitorious.org/svn2git/svn2git.git;
    rev = "197979b6a641b8b5fa4856c700b1235491c73a41";
    sha256 = "fce3749b3db4940060c6065e927248afe18fd698f30ded6cddba201b67e5351c";
  };

  buildPhase = ''
    qmake
    make CXXFLAGS='-I${apr}/include/apr-1 -I${subversion}/include/subversion-1 -DVER="\"${src.rev}\""'
  '';

  installPhase = ''
    ensureDir $out/bin
    cp svn-all-fast-export $out/bin
  '';

  buildInputs = [subversion apr qt47];
  
}

{ stdenv, fetchgit, qt47, subversion, apr}:

stdenv.mkDerivation rec {
  name = "svn2git";

  src = fetchgit {
    url = http://git.gitorious.org/svn2git/svn2git.git;
    rev = "197979b6a641b8b5fa4856c700b1235491c73a41";
    sha256 = "7be1a8f5822aff2d4ea7f415dce0b4fa8c6a82310acf24e628c5f1ada2d2d613";
  };

  buildPhase = ''
    sed -i 's|/bin/cat|cat|' ./src/repository.cpp
    qmake
    make CXXFLAGS='-I${apr}/include/apr-1 -I${subversion}/include/subversion-1 -DVER="\"${src.rev}\""'
  '';

  installPhase = ''
    ensureDir $out/bin
    cp svn-all-fast-export $out/bin
  '';

  buildInputs = [subversion apr qt47];
  
}

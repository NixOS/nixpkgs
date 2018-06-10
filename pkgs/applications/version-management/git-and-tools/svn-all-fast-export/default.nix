{ stdenv, fetchFromGitHub, fetchpatch, qmake, qtbase, qttools, subversion, apr }:

let
  version = "1.0.12";
in
stdenv.mkDerivation {
  name = "svn-all-fast-export-${version}";

  src = fetchFromGitHub {
    owner = "svn-all-fast-export";
    repo = "svn2git";
    rev = version;
    sha256 = "158w2ynz16dlp992g8nfk7v2f5962z88b4xyv5dyjvbl4l1v7r0v";
  };

  nativeBuildInputs = [ qmake qttools ];
  buildInputs = [ apr.dev subversion.dev qtbase ];

  qmakeFlags = [
    "VERSION=${version}"
    "APR_INCLUDE=${apr.dev}/include/apr-1"
    "SVN_INCLUDE=${subversion.dev}/include/subversion-1"
  ];

  meta = with stdenv.lib; {
    homepage = https://github.com/svn-all-fast-export/svn2git;
    description = "A fast-import based converter for an svn repo to git repos";
    license = licenses.gpl3;
    platforms = platforms.all;
    maintainers = [ maintainers.flokli ];
  };
}

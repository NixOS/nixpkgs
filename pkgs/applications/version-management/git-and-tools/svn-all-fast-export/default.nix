{ stdenv, fetchFromGitHub, fetchpatch, qmake, qtbase, qttools, subversion, apr }:

let
  version = "1.0.11";
in
stdenv.mkDerivation {
  name = "svn-all-fast-export-${version}";

  src = fetchFromGitHub {
    owner = "svn-all-fast-export";
    repo = "svn2git";
    rev = version;
    sha256 = "0lhnw8f15j4wkpswhrjd7bp9xkhbk32zmszaxayzfhbdl0g7pzwj";
  };

  # https://github.com/svn-all-fast-export/svn2git/pull/40
  patches = [
    (fetchpatch {
      name = "pr40.patch";
      sha256 = "1qndhk5csf7kddk3giailx7r0cdipq46lj73nkcws43n4n93synk";
      url = https://github.com/svn-all-fast-export/svn2git/pull/40.diff;
    })
  ];

  nativeBuildInputs = [ qmake qttools ];
  buildInputs = [ apr.dev subversion.dev qtbase ];

  qmakeFlags = [
    "VERSION=${version}"
    "APR_INCLUDE=${apr.dev}/include/apr-1"
    "SVN_INCLUDE=${subversion.dev}/include/subversion-1"
  ];

  installPhase = "make install INSTALL_ROOT=$out";

  meta = with stdenv.lib; {
    homepage = https://github.com/svn-all-fast-export/svn2git;
    description = "A fast-import based converter for an svn repo to git repos";
    license = licenses.gpl3;
    platforms = platforms.all;
    maintainers = [ maintainers.flokli ];
  };
}

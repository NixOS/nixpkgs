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
      sha256 = "0mwncklzncsifql9zlxlbj3clsif5p2v1xs8nmxrw44mqvaysjw3";
      url = https://github.com/svn-all-fast-export/svn2git/compare/f00d5a5...flokli:nixos-20180326.patch;
    })
  ];

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

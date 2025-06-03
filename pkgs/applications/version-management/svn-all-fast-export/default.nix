{
  lib,
  stdenv,
  fetchFromGitHub,
  qmake,
  qtbase,
  qttools,
  subversion,
  apr,
}:

let
  version = "1.0.20";
in
stdenv.mkDerivation {
  pname = "svn-all-fast-export";
  inherit version;

  src = fetchFromGitHub {
    owner = "svn-all-fast-export";
    repo = "svn2git";
    rev = version;
    sha256 = "sha256-ALZ9wGEM2woELUdCxG1SSzIhOCHERsnrSnCVN2MH9Lo=";
  };

  nativeBuildInputs = [
    qmake
    qttools
  ];
  buildInputs = [
    apr.dev
    subversion.dev
    qtbase
  ];

  qmakeFlags = [
    "VERSION=${version}"
    "APR_INCLUDE=${apr.dev}/include/apr-1"
    "SVN_INCLUDE=${subversion.dev}/include/subversion-1"
  ];

  NIX_LDFLAGS = "-lsvn_fs-1";

  dontWrapQtApps = true;

  meta = with lib; {
    homepage = "https://github.com/svn-all-fast-export/svn2git";
    description = "Fast-import based converter for an svn repo to git repos";
    license = licenses.gpl3;
    platforms = platforms.all;
    maintainers = [ maintainers.flokli ];
    mainProgram = "svn-all-fast-export";
  };
}

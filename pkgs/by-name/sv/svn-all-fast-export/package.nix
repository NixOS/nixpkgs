{
  lib,
  stdenv,
  fetchFromGitHub,
  qt6,
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
    qt6.qmake
    qt6.qttools
  ];
  buildInputs = [
    apr.dev
    subversion.dev
    qt6.qtbase
    qt6.qt5compat
  ];

  qmakeFlags = [
    "VERSION=${version}"
    "APR_INCLUDE=${apr.dev}/include/apr-1"
    "SVN_INCLUDE=${subversion.dev}/include/subversion-1"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    "CONFIG-=app_bundle"
  ];

  env.NIX_LDFLAGS = "-lsvn_fs-1";

  dontWrapQtApps = true;

  meta = {
    homepage = "https://github.com/svn-all-fast-export/svn2git";
    description = "Fast-import based converter for an svn repo to git repos";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.all;
    maintainers = [ lib.maintainers.flokli ];
    mainProgram = "svn-all-fast-export";
  };
}

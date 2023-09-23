{ mkDerivation
, lib
, fetchFromGitLab
, libnotify
, cmake
, ninja
, qtbase
, qtconnectivity
}:

mkDerivation rec {
  pname = "libcprime";
  version = "4.5.0";

  src = fetchFromGitLab {
    owner = "cubocore";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-j6WFLcjDMkYl+9HCmhMRttwtjNX05oP5mfdOsoLC7og=";
  };

  patches = [
    ./0001-fix-application-dirs.patch
  ];

  nativeBuildInputs = [
    cmake
    ninja
  ];

  buildInputs = [
    qtbase
    qtconnectivity
    libnotify
  ];

  meta = with lib; {
    description = "A library for bookmarking, saving recent activites, managing settings of C-Suite";
    homepage = "https://gitlab.com/cubocore/coreapps/libcprime";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ dan4ik605743 ];
    platforms = platforms.linux;
  };
}

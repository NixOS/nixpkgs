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
  version = "4.3.0";

  src = fetchFromGitLab {
    owner = "cubocore";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-+z5dXKaV2anN6OLMycEz87kDqQScgHHEKwGhDAdHSd4=";
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

{ mkDerivation, lib, fetchFromGitLab, qtbase, poppler, qtwebengine, cmake, ninja, libcprime, libcsys }:

mkDerivation rec {
  pname = "corepdf";
  version = "4.3.0";

  src = fetchFromGitLab {
    owner = "cubocore/coreapps";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-VwJ3H/jNP3u5C+LATPUSftiWm89upx77fN3NqzTnU7Y=";
  };

  nativeBuildInputs = [
    cmake
    ninja
  ];

  buildInputs = [
    qtbase
    poppler
    qtwebengine
    libcprime
    libcsys
  ];

  meta = with lib; {
    description = "A PDF viewer from the C Suite";
    homepage = "https://gitlab.com/cubocore/coreapps/corepdf";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ dan4ik605743 ];
    platforms = platforms.linux;
  };
}

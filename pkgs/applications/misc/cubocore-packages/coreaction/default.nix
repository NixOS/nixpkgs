{ mkDerivation, lib, fetchFromGitLab, qtsvg, qtbase, cmake, ninja, libcprime, libcsys }:

mkDerivation rec {
  pname = "coreaction";
  version = "4.3.0";

  src = fetchFromGitLab {
    owner = "cubocore/coreapps";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-XQ/GcSjGSe+3d0dJxjmmcBFoDzrmM6zsHMfbDdzmpPs=";
  };

  nativeBuildInputs = [
    cmake
    ninja
  ];

  buildInputs = [
    qtsvg
    qtbase
    libcprime
    libcsys
  ];

  meta = with lib; {
    description = "A side bar for showing widgets from the C Suite";
    homepage = "https://gitlab.com/cubocore/coreapps/coreaction";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ dan4ik605743 ];
    platforms = platforms.linux;
  };
}

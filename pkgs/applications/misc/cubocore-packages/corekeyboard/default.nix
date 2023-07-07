{ mkDerivation, lib, fetchFromGitLab, qtbase, qtx11extras, xorg, cmake, ninja, libcprime, libcsys }:

mkDerivation rec {
  pname = "corekeyboard";
  version = "4.4.0";

  src = fetchFromGitLab {
    owner = "cubocore/coreapps";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-zOH/w4QroMaVjWnFuWAJQ11RYlpXwIXRG9QYGDkfLVY=";
  };

  nativeBuildInputs = [
    cmake
    ninja
  ];

  buildInputs = [
    qtbase
    qtx11extras
    xorg.libXtst
    xorg.libX11
    libcprime
    libcsys
  ];

  meta = with lib; {
    description = "A virtual keyboard for X11 from the C Suite";
    homepage = "https://gitlab.com/cubocore/coreapps/corekeyboard";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ dan4ik605743 ];
    platforms = platforms.linux;
  };
}

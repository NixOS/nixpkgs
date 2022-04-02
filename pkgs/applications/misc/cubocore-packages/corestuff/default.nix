{ mkDerivation, lib, fetchFromGitLab, qtbase, qtx11extras, kglobalaccel, xorg, cmake, ninja, libcprime, libcsys }:

mkDerivation rec {
  pname = "corestuff";
  version = "4.3.0";

  src = fetchFromGitLab {
    owner = "cubocore/coreapps";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-snzW6cqxIyiXJLOD5MoEqmzen1aZN4IALESaIWIOMro=";
  };

  patches = [
    # Remove autostart
    ./0001-fix-installPhase.patch
  ];

  nativeBuildInputs = [
    cmake
    ninja
  ];

  buildInputs = [
    qtbase
    qtx11extras
    kglobalaccel
    xorg.libXcomposite
    libcprime
    libcsys
  ];

  meta = with lib; {
    description = "An activity viewer from the C Suite";
    homepage = "https://gitlab.com/cubocore/coreapps/corestuff";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ dan4ik605743 ];
    platforms = platforms.linux;
  };
}

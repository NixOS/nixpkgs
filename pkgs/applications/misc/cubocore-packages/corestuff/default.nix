{ mkDerivation, lib, fetchFromGitLab, qtbase, qtx11extras, kglobalaccel, xorg, cmake, ninja, libcprime, libcsys }:

mkDerivation rec {
  pname = "corestuff";
  version = "4.2.0";

  src = fetchFromGitLab {
    owner = "cubocore/coreapps";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-/mmCIHZXn/Jpjr37neI6owWuU1VO6o7wmRj6ZH8tUbo=";
  };

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

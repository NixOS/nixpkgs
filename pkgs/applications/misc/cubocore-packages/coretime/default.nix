{ mkDerivation, lib, fetchFromGitLab, qtbase, qtmultimedia, cmake, ninja, libcprime, libcsys }:

mkDerivation rec {
  pname = "coretime";
  version = "4.3.0";

  src = fetchFromGitLab {
    owner = "cubocore/coreapps";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-MIcmgBfgyjEyJxXCq6IbQ/i6IdtL5cWVGpV2YZbzK58=";
  };

  nativeBuildInputs = [
    cmake
    ninja
  ];

  buildInputs = [
    qtbase
    qtmultimedia
    libcprime
    libcsys
  ];

  meta = with lib; {
    description = "A time related task manager from the C Suite";
    homepage = "https://gitlab.com/cubocore/coreapps/coretime";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ dan4ik605743 ];
    platforms = platforms.linux;
  };
}

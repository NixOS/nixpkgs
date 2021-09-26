{ mkDerivation, lib, fetchFromGitLab, qtbase, qtmultimedia, cmake, ninja, libcprime, libcsys }:

mkDerivation rec {
  pname = "coretime";
  version = "4.2.0";

  src = fetchFromGitLab {
    owner = "cubocore/coreapps";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-b7oqHhsuHsy96IAXPUtw+WqneEHgn/nUDgHiJt2aXXM=";
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

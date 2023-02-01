{ mkDerivation, lib, fetchFromGitLab, qtbase, libarchive, libarchive-qt, cmake, ninja, libcprime, libcsys }:

mkDerivation rec {
  pname = "coregarage";
  version = "4.4.0";

  src = fetchFromGitLab {
    owner = "cubocore/coreapps";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-NsCJS+FyHWj2aLXlbzxcHEcdZ2cViZmJlh501/48xdI=";
  };

  nativeBuildInputs = [
    cmake
    ninja
  ];

  buildInputs = [
    qtbase
    libarchive
    libarchive-qt
    libcprime
    libcsys
  ];

  meta = with lib; {
    description = "A settings manager for the C Suite";
    homepage = "https://gitlab.com/cubocore/coreapps/coregarage";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ dan4ik605743 ];
    platforms = platforms.linux;
  };
}

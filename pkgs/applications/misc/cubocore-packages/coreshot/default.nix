{ mkDerivation, lib, fetchFromGitLab, qtbase, qtx11extras, cmake, ninja, libcprime, libcsys }:

mkDerivation rec {
  pname = "coreshot";
  version = "4.4.0";

  src = fetchFromGitLab {
    owner = "cubocore/coreapps";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-K/K6630ctWG856igXF1fAukwu6FbsBzF8JxG8K3gICc=";
  };

  nativeBuildInputs = [
    cmake
    ninja
  ];

  buildInputs = [
    qtbase
    qtx11extras
    libcprime
    libcsys
  ];

  meta = with lib; {
    description = "A screen capture utility from the C Suite";
    homepage = "https://gitlab.com/cubocore/coreapps/coreshot";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ dan4ik605743 ];
    platforms = platforms.linux;
  };
}

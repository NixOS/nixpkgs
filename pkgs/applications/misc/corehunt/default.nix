{ mkDerivation, lib, fetchFromGitLab, qtbase, libcprime, cmake, ninja }:

mkDerivation rec {
  pname = "corehunt";
  version = "4.2.0";

  src = fetchFromGitLab {
    owner = "cubocore/coreapps";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-KnIqLI8MtLirFycW2YNHAjS7EDfU3dpqb6vVq9Tl6Ow=";
  };

  nativeBuildInputs = [
    cmake
    ninja
  ];

  buildInputs = [
    qtbase
    libcprime
  ];

  meta = with lib; {
    description = "A file finder utility from the C Suite";
    homepage = "https://gitlab.com/cubocore/coreapps/corehunt";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ dan4ik605743 ];
    platforms = platforms.linux;
  };
}

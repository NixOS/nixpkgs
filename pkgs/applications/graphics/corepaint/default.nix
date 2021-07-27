{ mkDerivation, lib, fetchFromGitLab, qtbase, libcprime, cmake, ninja }:

mkDerivation rec {
  pname = "corepaint";
  version = "4.2.0";

  src = fetchFromGitLab {
    owner = "cubocore/coreapps";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-nATraYm7FZEXoNWgXt1G86KdrAvRgM358F+YdfWcnkg=";
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
    description = "A paint app from the C Suite";
    homepage = "https://gitlab.com/cubocore/coreapps/corepaint";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ dan4ik605743 ];
    platforms = platforms.linux;
  };
}

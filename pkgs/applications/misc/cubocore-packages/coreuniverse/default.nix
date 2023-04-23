{ mkDerivation, lib, fetchFromGitLab, qtbase, cmake, ninja, libcprime, libcsys }:

mkDerivation rec {
  pname = "coreuniverse";
  version = "4.4.0";

  src = fetchFromGitLab {
    owner = "cubocore/coreapps";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-ThEzuwBrPUkXURcW9KiXJs8ExqYWZamlfeQ1IggMWdc=";
  };

  nativeBuildInputs = [
    cmake
    ninja
  ];

  buildInputs = [
    qtbase
    libcprime
    libcsys
  ];

  meta = with lib; {
    description = "Shows information about apps from the C Suite";
    homepage = "https://gitlab.com/cubocore/coreapps/coreuniverse";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ dan4ik605743 ];
    platforms = platforms.linux;
  };
}

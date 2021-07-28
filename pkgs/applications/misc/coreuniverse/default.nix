{ mkDerivation, lib, fetchFromGitLab, qtbase, libcprime, cmake, ninja }:

mkDerivation rec {
  pname = "coreuniverse";
  version = "4.2.0";

  src = fetchFromGitLab {
    owner = "cubocore/coreapps";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-YZCMyYMAvd/xQYNUnURIvmQwaM+X+Ql93OS4ZIyAZLY=";
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
    description = "Shows information about apps from the C Suite";
    homepage = "https://gitlab.com/cubocore/coreapps/coreuniverse";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ dan4ik605743 ];
    platforms = platforms.linux;
  };
}

{ mkDerivation, lib, fetchFromGitLab, qtbase, lm_sensors, cmake, ninja, libcprime, libcsys }:

mkDerivation rec {
  pname = "corestats";
  version = "4.5.0";

  src = fetchFromGitLab {
    owner = "cubocore/coreapps";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-584dSlXhPfvTBeDjex1o2TZPoG40tl1fNDiIYqjyzOI=";
  };

  nativeBuildInputs = [
    cmake
    ninja
  ];

  buildInputs = [
    qtbase
    lm_sensors
    libcprime
    libcsys
  ];

  meta = with lib; {
    description = "A system resource viewer from the C Suite";
    mainProgram = "corestats";
    homepage = "https://gitlab.com/cubocore/coreapps/corestats";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ dan4ik605743 ];
    platforms = platforms.linux;
  };
}

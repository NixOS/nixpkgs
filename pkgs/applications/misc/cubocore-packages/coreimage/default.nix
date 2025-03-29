{
  mkDerivation,
  lib,
  fetchFromGitLab,
  qtbase,
  cmake,
  ninja,
  libcprime,
  libcsys,
}:

mkDerivation rec {
  pname = "coreimage";
  version = "4.5.0";

  src = fetchFromGitLab {
    owner = "cubocore/coreapps";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-SyGIeoYC4bTBWZ0adOfYJpWkW3/bvFNZg5zK2MN27kA=";
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
    description = "Image viewer from the C Suite";
    mainProgram = "coreimage";
    homepage = "https://gitlab.com/cubocore/coreapps/coreimage";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ dan4ik605743 ];
    platforms = platforms.linux;
  };
}

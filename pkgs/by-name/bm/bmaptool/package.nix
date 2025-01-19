{
  lib,
  fetchFromGitHub,
  python3Packages,
}:

python3Packages.buildPythonApplication rec {
  pname = "bmaptool";
  version = "3.8.0";

  src = fetchFromGitHub {
    owner = "yoctoproject";
    repo = "bmaptool";
    rev = "v${version}";
    hash = "sha256-YPY3sNuZ/TASNBPH94iqG6AuBRq5KjioKiuxAcu94+I=";
  };

  propagatedBuildInputs = with python3Packages; [ six ];

  # tests fail only on hydra.
  doCheck = false;

  meta = {
    description = "BMAP Tools";
    homepage = "https://github.com/yoctoproject/bmaptool";
    license = lib.licenses.gpl2Only;
    maintainers = [ lib.maintainers.dezgeg ];
    platforms = lib.platforms.linux;
    mainProgram = "bmaptool";
  };
}

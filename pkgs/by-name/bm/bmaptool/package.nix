{
  lib,
  fetchFromGitHub,
  python3Packages,
}:

python3Packages.buildPythonApplication rec {
  pname = "bmaptool";
  version = "3.9.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "yoctoproject";
    repo = "bmaptool";
    rev = "v${version}";
    hash = "sha256-9KSBv420HJvK5fUg7paFJqA2MCw36BfaeAG4NME/co8=";
  };

  build-system = [
    python3Packages.hatchling
  ];

  propagatedBuildInputs = with python3Packages; [ six ];

  # tests fail only on hydra.
  doCheck = false;

  meta = with lib; {
    description = "BMAP Tools";
    homepage = "https://github.com/yoctoproject/bmaptool";
    license = licenses.gpl2Only;
    maintainers = [ maintainers.dezgeg ];
    platforms = platforms.linux;
    mainProgram = "bmaptool";
  };
}

{
  lib,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "rdwatool";
  version = "1.2-unstable-2023-11-27";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "p0dalirius";
    repo = "RDWAtool";
    rev = "60b7816f06d155bd3d218b76b69d9419b8a82dbe";
    hash = "sha256-0mjnZiF8DxVbI8Lr12b7jzn+x+mn6Mel8LaIy8heEdI=";
  };

  pythonRelaxDeps = [
    "urllib3"
  ];

  pythonRemoveDeps = [
    "bs4"
  ];

  nativeBuildInputs = with python3.pkgs; [
    setuptools
  ];

  propagatedBuildInputs = with python3.pkgs; [
    beautifulsoup4
    requests
    urllib3
    xlsxwriter
  ];

  pythonImportsCheck = [
    "rdwatool"
  ];

  meta = with lib; {
    description = "Tool to extract information from a Microsoft Remote Desktop Web Access (RDWA) application";
    homepage = "https://github.com/p0dalirius/RDWAtool";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ fab ];
    mainProgram = "rdwatool";
  };
}

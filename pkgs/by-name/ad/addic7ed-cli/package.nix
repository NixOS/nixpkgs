{
  lib,
  python3Packages,
  fetchPypi,
}:

python3Packages.buildPythonApplication rec {
  pname = "addic7ed-cli";
  version = "1.4.6";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "182cpwxpdybsgl1nps850ysvvjbqlnx149kri4hxhgm58nqq0qf5";
  };

  build-system = with python3Packages; [
    setuptools
  ];

  dependencies = with python3Packages; [
    requests
    pyquery
  ];

  # Tests require network access
  doCheck = false;
  pythonImportsCheck = [ "addic7ed_cli" ];

  meta = {
    description = "Commandline access to addic7ed subtitles";
    homepage = "https://github.com/BenoitZugmeyer/addic7ed-cli";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ aethelz ];
    platforms = lib.platforms.unix;
    mainProgram = "addic7ed";
  };
}

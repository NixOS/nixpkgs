{
  stdenv,
  lib,
  python3Packages,
  fetchPypi,
}:

python3Packages.buildPythonApplication rec {
  pname = "piston-cli";
  version = "1.5.0";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-YzQo22/63IJ78Y7pqk7W1galI+HNk7gIodiDlHwNllY=";
  };

  propagatedBuildInputs = with python3Packages; [
    appdirs
    click
    coloredlogs
    more-itertools
    prompt-toolkit
    pygments
    pyyaml
    requests
    requests-cache
    rich
  ];

  checkPhase = ''
    $out/bin/piston --help > /dev/null
  '';

  nativeBuildInputs = with python3Packages; [
    poetry-core
  ];

  pythonRelaxDeps = [
    "rich"
    "more-itertools"
    "PyYAML"
  ];

  meta = with lib; {
    broken = stdenv.hostPlatform.isDarwin;
    description = "Piston api tool";
    homepage = "https://github.com/Shivansh-007/piston-cli";
    license = licenses.mit;
    maintainers = with maintainers; [ ethancedwards8 ];
    mainProgram = "piston";
  };
}

{
  lib,
  python3Packages,
  fetchPypi,
}:

python3Packages.buildPythonApplication rec {
  pname = "b2-tools";
  version = "4.2.0";
  pyproject = true;

  src = fetchPypi {
    inherit version;
    pname = "b2";
    hash = "sha256-ub4sscblLBzulIryZWGdBJusYuSXDeKaPMAb/2JclTk=";
  };

  build-system = with python3Packages; [
    setuptools
  ];

  dependencies = with python3Packages; [
    argcomplete
    arrow
    b2sdk
    docutils
    phx-class-registry
    platformdirs
    rst2ansi
    tabulate
    tqdm
  ];

  nativeBuildInputs = with python3Packages; [
    pdm-backend
  ];

  meta = with lib; {
    description = "The command-line tool that gives easy access to all of the capabilities of B2 Cloud Storage.";
    homepage = "https://github.com/Backblaze/B2_Command_Line_Tool";
    changelog = "https://github.com/Backblaze/B2_Command_Line_Tool/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ pmw ];
  };

}

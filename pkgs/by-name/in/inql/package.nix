{
  lib,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "inql";
  version = "4.0.6";
  format = "pyproject";
  src = fetchFromGitHub {
    owner = "doyensec";
    repo = "inql";
    tag = "v${version}";
    hash = "sha256-DFGJHqdrCmOZn8GdY5SZ1PrOhuIsMLoK+2Fry9WkRiY=";
  };

  postPatch = ''
    # To set the version a full git checkout would be needed
    substituteInPlace setup.py \
      --replace-fail "version=version()," "version='${version}',"
  '';

  build-system = with python3.pkgs; [
    setuptools
  ];

  dependencies = with python3.pkgs; [
    stickytape
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [
    "inql"
  ];

  meta = {
    description = "Security testing tool for GraphQL";
    mainProgram = "inql";
    homepage = "https://github.com/doyensec/inql";
    changelog = "https://github.com/doyensec/inql/releases/tag/v${version}";
    license = with lib.licenses; [ asl20 ];
    maintainers = with lib.maintainers; [ fab ];
  };
}

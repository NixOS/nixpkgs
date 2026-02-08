{
  lib,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "crlfsuite";
  version = "2.5.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Nefcore";
    repo = "CRLFsuite";
    tag = "v${finalAttrs.version}";
    sha256 = "sha256-mK20PbVGhTEjhY5L6coCzSMIrG/PHHmNq30ZoJEs6uI=";
  };

  build-system = with python3.pkgs; [
    setuptools
  ];

  dependencies = with python3.pkgs; [
    colorama
    requests
  ];

  # No tests present
  doCheck = false;

  pythonImportsCheck = [
    "crlfsuite"
  ];

  meta = {
    description = "CRLF injection (HTTP Response Splitting) scanner";
    mainProgram = "crlfsuite";
    homepage = "https://github.com/Nefcore/CRLFsuite";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      c0bw3b
      fab
    ];
  };
})

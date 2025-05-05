{
  buildPythonPackage,
  faust-cchardet,
  fetchFromGitHub,
  httplib2,
  lib,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pytouchline-extended";
  version = "0.4.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "brondum";
    repo = "pytouchline";
    tag = version;
    hash = "sha256-fcqm5fRuxB4YQkP48UclGgo4KohXu2OU7w1Nr6i9c6s=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail '$GITHUB_REF_NAME' '${version}'
  '';

  build-system = [ setuptools ];

  dependencies = [
    faust-cchardet
    httplib2
  ];

  pythonImportsCheck = [ "pytouchline_extended" ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = {
    changelog = "https://github.com/brondum/pytouchline/releases/tag/${src.tag}";
    description = "Roth Touchline interface library";
    homepage = "https://github.com/brondum/pytouchline";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}

{
  lib,
  fetchPypi,
  buildPythonPackage,

  matplotlib,
  numpy,
  scipy,
  tqdm,
  scikit-learn,
  scikit-image,

  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "lime";
  version = "0.2.0.1";
  format = "setuptools";

  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-dpYOTwVf61Pom1AiODuvyHtj8lusYmWYSwozPRpX94E=";
  };

  postPatch = ''
    substituteInPlace lime/tests/test_scikit_image.py \
      --replace-fail "random_seed" "rng"
  '';

  propagatedBuildInputs = [
    matplotlib
    numpy
    scipy
    tqdm
    scikit-learn
    scikit-image
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTestPaths = [
    # touches network
    "lime/tests/test_lime_text.py"
  ];

  pythonImportsCheck = [
    "lime.exceptions"
    "lime.explanation"
    "lime.lime_base"
    "lime.lime_image"
    "lime.lime_text"
  ];

  meta = {
    description = "Local Interpretable Model-Agnostic Explanations for machine learning classifiers";
    homepage = "https://github.com/marcotcr/lime";
    changelog = "https://github.com/marcotcr/lime/releases/tag/${version}";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ khaser ];
  };
}

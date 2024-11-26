{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  setuptools,
  mutf8,
  webassets,
  pytestCheckHook,
  mock,
}:

buildPythonPackage rec {
  pname = "dukpy";
  version = "0.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "amol-";
    repo = "dukpy";
    rev = "refs/tags/${version}";
    hash = "sha256-8RDMz9SfBoUe7LQ9/atsZlJ/2uwLUb0hZxeYdsUOGpU=";
  };

  postPatch = ''
    substituteInPlace tests/test_webassets_filter.py \
      --replace-fail "class PyTestTemp" "class _Temp" \
      --replace-fail "PyTestTemp" "Temp"
  '';

  build-system = [ setuptools ];

  dependencies = [ mutf8 ];

  optional-dependencies = {
    webassets = [ webassets ];
  };

  nativeCheckInputs = [
    pytestCheckHook
    mock
  ] ++ optional-dependencies.webassets;

  disabledTests = [ "test_installer" ];

  preCheck = ''
    rm -r dukpy
  '';

  pythonImportsCheck = [ "dukpy" ];

  meta = {
    description = "Simple JavaScript interpreter for Python";
    homepage = "https://github.com/amol-/dukpy";
    changelog = "https://github.com/amol-/dukpy/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ruby0b ];
    mainProgram = "dukpy";
  };
}

{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  ply,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "jsonpath-ng";
  version = "1.6.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "h2non";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-0ErTGxGlMn/k2KMwRV26WJpx85yJUfn6Hgp5pU4RZA4=";
  };

  propagatedBuildInputs = [
    ply
    setuptools
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTestPaths = [
    # Exclude tests that require oslotest
    "tests/test_jsonpath_rw_ext.py"
  ];

  pythonImportsCheck = [ "jsonpath_ng" ];

  meta = with lib; {
    description = "JSONPath implementation";
    mainProgram = "jsonpath_ng";
    homepage = "https://github.com/h2non/jsonpath-ng";
    changelog = "https://github.com/h2non/jsonpath-ng/blob/v${version}/History.md";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}

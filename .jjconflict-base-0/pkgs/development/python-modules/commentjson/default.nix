{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  six,
  lark,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "commentjson";
  version = "0.9.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "vaidik";
    repo = "commentjson";
    rev = "v${version}";
    hash = "sha256-dPnIcv7TIeyG7rU938w7FrDklmaGuPpXz34uw/JjOgY=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "lark-parser>=0.7.1,<0.8.0" "lark"

    # NixOS is missing test.test_json module
    rm -r commentjson/tests/test_json
  '';

  propagatedBuildInputs = [
    lark
    six
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "commentjson" ];

  meta = with lib; {
    description = "Add JavaScript or Python style comments in JSON";
    homepage = "https://github.com/vaidik/commentjson/";
    license = licenses.mit;
    maintainers = [ ];
  };
}

{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  isPy27,
  falcon,
  requests,
  pytestCheckHook,
  marshmallow,
  mock,
  numpy,
}:

buildPythonPackage rec {
  pname = "hug";
  version = "2.6.0";
  format = "setuptools";
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "hugapi";
    repo = pname;
    rev = version;
    sha256 = "05rsv16g7ph100p8kl4l2jba0y4wcpp3xblc02mfp67zp1279vaq";
  };

  propagatedBuildInputs = [
    falcon
    requests
  ];

  nativeCheckInputs = [
    mock
    marshmallow
    pytestCheckHook
    numpy
  ];

  postPatch = ''
    substituteInPlace setup.py --replace '"pytest-runner"' ""
  '';

  preCheck = ''
    # some tests need the `hug` CLI on the PATH
    export PATH=$out/bin:$PATH
  '';

  disabledTests = [
    # some tests attempt network access
    "test_datagram_request"
    "test_request"
    # these tests use an unstable test dependency (https://github.com/hugapi/hug/issues/859)
    "test_marshmallow_custom_context"
    "test_marshmallow_schema"
    "test_transform"
    "test_validate_route_args_negative_case"
  ];

  meta = with lib; {
    description = "Python framework that makes developing APIs as simple as possible, but no simpler";
    homepage = "https://github.com/hugapi/hug";
    license = licenses.mit;
    # Missing support for later falcon releases
    broken = true;
  };
}

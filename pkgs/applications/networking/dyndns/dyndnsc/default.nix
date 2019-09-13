{ lib, buildPythonPackage, fetchPypi, isPy27, pytestrunner, setuptools, daemonocle, dnspython
, netifaces, requests, bottle, pytest, ndg-httpsclient, ipy, mock }:

buildPythonPackage rec {
  pname = "dyndnsc";
  version = "0.5.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1p8dgfhvks1bjvq8gww4yvi3g8fam2m5irirkf7xjhs8g38r8bjb";
  };
  postPatch = ''
    # loosen some dependency requirements
    substituteInPlace setup.py \
      --replace "pytest>=3.2.5,<5.0.0" "pytest>=3.2.5" \
      --replace '"argparse",' "" \
      --replace "bottle==" "bottle>="

    # skip test that needs internet
    substituteInPlace dyndnsc/tests/detector/test_dnswanip.py \
      --replace "def test_dnswanip_detector_ipv4" "@pytest.mark.skip"$'\n'"    def test_dnswanip_detector_ipv4"
  '';

  nativeBuildInputs = [ pytestrunner ];

  propagatedBuildInputs = [ daemonocle dnspython netifaces requests setuptools ]
    ++ lib.optionals isPy27 [ ndg-httpsclient ipy ];

  checkInputs = [ bottle pytest ] ++ lib.optional isPy27 mock;

  # Some of the tests use localhost networking.
  __darwinAllowLocalNetworking = true;

  meta = with lib; {
    description = "Dynamic dns update client written in Python";
    homepage = "https://github.com/infothrill/python-dyndnsc";
    license = licenses.mit;
    maintainers = with maintainers; [ b4dm4n ];
  };
}

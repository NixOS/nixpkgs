{ lib, fetchFromGitHub, python3Packages, toil, testVersion }:

python3Packages.buildPythonApplication rec {
  pname = "toil";
  version = "5.4.0";

  src = python3Packages.fetchPypi {
    inherit pname version;
    sha256 = "73c0648828bd3610c07b7648dd06d6ec27efefdb09473bf01d05d91eb899c9fd";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "docker = " "docker = 'docker' #" \
      --replace "addict = " "addict = 'addict' #"
  '';

  propagatedBuildInputs = with python3Packages; [
    addict
    docker
    pytz
    pyyaml
    enlighten
    psutil
    python-dateutil
    dill
  ];
  checkInputs = with python3Packages; [ pytestCheckHook ];

  pytestFlagsArray = [ "src/toil/test" ];
  pythonImportsCheck = [ "toil" ];

  passthru.tests.version = testVersion { package = toil; };

  meta = with lib; {
    homepage = "https://toil.ucsc-cgl.org/";
    license = with licenses; [ asl20 ];
    description = "Workflow engine written in pure Python";
    maintainers = with maintainers; [ veprbl ];
  };
}

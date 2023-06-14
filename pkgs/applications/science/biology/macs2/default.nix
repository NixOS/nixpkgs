{ lib, python3, fetchPypi }:

python3.pkgs.buildPythonPackage rec {
  pname = "macs2";
  version = "2.2.8";
  format = "pyproject";

  src = fetchPypi {
    pname = lib.toUpper pname;
    inherit version;
    hash = "sha256-KgpDasidj4yUoeQQaQA3dg5eN5Ka1xnFRpbnTvhKmOA=";
  };

  postPatch = ''
    # prevent setup.py from installing numpy
    substituteInPlace setup.py \
      --replace "subprocess.call([sys.executable, \"-m\", 'pip', 'install', f'numpy{numpy_requires}'],cwd=cwd)" "0"
  '';

  nativeBuildInputs = with python3.pkgs; [
    cython
    setuptools
  ];

  propagatedBuildInputs = with python3.pkgs; [ numpy ];

  nativeCheckInputs = [
    python3.pkgs.unittestCheckHook
  ];

  unittestFlagsArray = [
    "-s"
    "test"
  ];

  pythonImportsCheck = [ "MACS2" ];

  meta = with lib; {
    description = "Model-based Analysis for ChIP-Seq";
    homepage = "https://github.com/macs3-project/MACS/";
    changelog = "https://github.com/macs3-project/MACS/releases/tag/v${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ gschwartz ];
  };
}

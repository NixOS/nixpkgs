{ lib, python3, fetchpatch, fetchPypi }:

python3.pkgs.buildPythonPackage rec {
  pname = "macs2";
  version = "2.2.9.1";
  format = "pyproject";

  src = fetchPypi {
    pname = lib.toUpper pname;
    inherit version;
    hash = "sha256-jVa8N/uCP8Y4fXgTjOloQFxUoKjNl3ZoJwX9CYMlLRY=";
  };

  patches = [
    # https://github.com/macs3-project/MACS/pull/590
    (fetchpatch {
      name = "remove-pip-build-dependency.patch";
      url = "https://github.com/macs3-project/MACS/commit/cf95a930daccf9f16e5b9a9224c5a2670cf67939.patch";
      hash = "sha256-WB3Ubqk5fKtZt97QYo/sZDU/yya9MUo1NL4VsKXR+Yo=";
    })
  ];

  nativeBuildInputs = with python3.pkgs; [
    cython_0
    numpy
    setuptools
    wheel
  ];

  propagatedBuildInputs = with python3.pkgs; [
    numpy
  ];

  __darwinAllowLocalNetworking = true;

  nativeCheckInputs = with python3.pkgs; [
    unittestCheckHook
  ];

  unittestFlagsArray = [
    "-s"
    "test"
  ];

  pythonImportsCheck = [ "MACS2" ];

  meta = with lib; {
    description = "Model-based Analysis for ChIP-Seq";
    mainProgram = "macs2";
    homepage = "https://github.com/macs3-project/MACS/";
    changelog = "https://github.com/macs3-project/MACS/releases/tag/v${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ gschwartz ];
  };
}

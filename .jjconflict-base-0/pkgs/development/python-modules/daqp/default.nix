{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  unittestCheckHook,
  cython_0,
  setuptools,
  wheel,
  numpy,
}:
buildPythonPackage rec {
  pname = "daqp";
  version = "0.6.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "darnstrom";
    repo = "daqp";
    rev = "refs/tags/v${version}";
    hash = "sha256-9sPYyd8J78HKDxbwkogu8tW38rgYIctEWqrriqJKy0M=";
  };

  sourceRoot = "${src.name}/interfaces/daqp-python";

  postPatch = ''
    sed -i 's|../../../daqp|../..|' setup.py
    sed -i 's|if src_path and os.path.exists(src_path):|if False:|' setup.py
  '';

  nativeCheckInputs = [ unittestCheckHook ];

  unittestFlagsArray = [
    "-s"
    "test"
    "-p"
    "'*.py'"
    "-v"
  ];

  nativeBuildInputs = [
    cython_0
    setuptools
    wheel
  ];

  propagatedBuildInputs = [ numpy ];

  pythonImportsCheck = [ "daqp" ];

  meta = with lib; {
    description = "Dual active-set algorithm for convex quadratic programming";
    homepage = "https://github.com/darnstrom/daqp";
    license = licenses.mit;
    maintainers = with maintainers; [ renesat ];
  };
}

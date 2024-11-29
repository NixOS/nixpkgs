{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  isPy27,
  setuptools,
  regex,
  csvw,
  clldutils,
  pytestCheckHook,
  pytest-mock,
}:

buildPythonPackage rec {
  pname = "segments";
  version = "2.2.1";
  pyproject = true;
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "cldf";
    repo = "segments";
    rev = "v${version}";
    sha256 = "sha256-Z9AQnsK/0HUCZDzdpQKNfSBWxfAOjWNBytcfI6yBY84=";
  };

  patchPhase = ''
    substituteInPlace setup.cfg \
      --replace-fail "--cov" ""
  '';

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    regex
    csvw
    clldutils
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-mock
  ];

  meta = with lib; {
    changelog = "https://github.com/cldf/segments/blob/${src.rev}/CHANGES.md";
    description = "Unicode Standard tokenization routines and orthography profile segmentation";
    mainProgram = "segments";
    homepage = "https://github.com/cldf/segments";
    license = licenses.asl20;
    maintainers = [ ];
  };
}

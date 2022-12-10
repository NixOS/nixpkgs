{ lib
, fetchFromGitHub
, python3
, rustPlatform
}:

python3.pkgs.buildPythonPackage rec {
  pname = "word-count";
  version = "0.13.2";

  format = "pyproject";

  src = fetchFromGitHub {
    owner = "PyO3";
    repo = "pyo3";
    rev = "v${version}";
    hash = "sha256-NOMrrfo8WjlPhtGxWUOPJS/UDDdbLQRCXR++Zd6JmIA=";
  };

  cargoDeps = rustPlatform.importCargoLock {
    lockFile = ./Cargo.lock;
  };

  postPatch = ''
    cp ${./Cargo.lock} Cargo.lock
  '';

  buildAndTestSubdir = "examples/word-count";

  nativeBuildInputs = with rustPlatform; [
    cargoSetupHook
    maturinBuildHook
  ];

  pythonImportsCheck = [ "word_count" ];

  meta = with lib; {
    description = "PyO3 word count example";
    homepage = "https://github.com/PyO3/pyo3";
    license = licenses.asl20;
    maintainers = [ ];
  };
}

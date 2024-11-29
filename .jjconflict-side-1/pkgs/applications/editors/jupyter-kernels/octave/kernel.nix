{ lib, python3Packages, fetchPypi }:

with python3Packages;

buildPythonPackage rec {
  pname = "octave-kernel";
  version = "0.34.2";

  src = fetchPypi {
    pname = "octave_kernel";
    inherit version;
    sha256 = "sha256-5ki2lekfK7frPsmPBIzYQOfANCUY9x+F2ZRAQSdPTxo=";
  };

  propagatedBuildInputs = [ metakernel ipykernel ];

  # Tests fail because the kernel appears to be halting or failing to launch
  # There appears to be a similar problem with metakernel's tests
  doCheck = false;

  meta = {
    description = "Jupyter kernel for Octave";
    homepage = "https://github.com/Calysto/octave_kernel";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ thomasjm ];
    platforms = lib.platforms.all;
  };
}

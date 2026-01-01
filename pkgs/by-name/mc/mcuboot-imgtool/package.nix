{
  lib,
  fetchPypi,
  python3Packages,
  nix-update-script,
}:

python3Packages.buildPythonApplication rec {
  pname = "mcuboot-imgtool";
<<<<<<< HEAD
  version = "2.3.0";
=======
  version = "2.2.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchPypi {
    inherit version;
    pname = "imgtool";
<<<<<<< HEAD
    hash = "sha256-//cuTnk6wOwCpJPBlUhxXMwKI1ivruqhC0nMwuC9EpU=";
=======
    hash = "sha256-XIc6EYleNtDrmeg2akOjriJwzE9Bnja2k0KJGCVRZM8=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  passthru.updateScript = nix-update-script { };

  nativeBuildInputs = with python3Packages; [ setuptools ];

  propagatedBuildInputs = with python3Packages; [
    cbor2
    click
    cryptography
    intelhex
    pyyaml
  ];

<<<<<<< HEAD
  meta = {
    description = "MCUboot's image signing and key management";
    homepage = "https://github.com/mcu-tools/mcuboot/tree/main/scripts";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ otavio ];
=======
  meta = with lib; {
    description = "MCUboot's image signing and key management";
    homepage = "https://github.com/mcu-tools/mcuboot/tree/main/scripts";
    license = licenses.asl20;
    maintainers = with maintainers; [ otavio ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "imgtool";
  };
}

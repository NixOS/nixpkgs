{
  lib,
  fetchPypi,
  python3Packages,
  nix-update-script,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "mcuboot-imgtool";
  version = "2.3.0";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) version;
    pname = "imgtool";
    hash = "sha256-//cuTnk6wOwCpJPBlUhxXMwKI1ivruqhC0nMwuC9EpU=";
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

  meta = {
    description = "MCUboot's image signing and key management";
    homepage = "https://github.com/mcu-tools/mcuboot/tree/main/scripts";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ otavio ];
    mainProgram = "imgtool";
  };
})

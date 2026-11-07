{
  lib,
  fetchFromGitHub,
  python3Packages,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "ciel";
  version = "3.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "fossi-foundation";
    repo = "ciel";
    tag = finalAttrs.version;
    hash = "sha256-qJ14rnR9FJ4DXPIhnJfUbuZUjde6V8AOcoP16mKwXuA=";
  };

  build-system = [ python3Packages.poetry-core ];

  dependencies = with python3Packages; [
    pyyaml
    click
    httpx
    pcpp
    rich
    zstandard
  ];

  meta = {
    description = "Tool for managing Process Design Kits (PDKs) for ASIC and FPGA flows";
    homepage = "https://github.com/fossi-foundation/ciel";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ gonsolo ];
    mainProgram = "ciel";
  };
})

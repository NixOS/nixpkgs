{
  lib,
  fetchFromGitHub,
  python3Packages,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "ciel";
  version = "2.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "fossi-foundation";
    repo = "ciel";
    tag = finalAttrs.version;
    hash = "sha256-AWbkHL0zO3tD0mE3dZIcj8mVND7o3imTxOpEfOtlRDI=";
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

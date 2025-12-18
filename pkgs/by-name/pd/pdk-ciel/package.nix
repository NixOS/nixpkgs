{
  lib,
  fetchFromGitHub,
  python3Packages,
}:

python3Packages.buildPythonApplication rec {
  pname = "ciel";
  version = "2.3.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "fossi-foundation";
    repo = "ciel";
    tag = version;
    hash = "sha256-/B4s0X+/2rTkR81zK5fwFKmMAgfFYH2n/6etH7WYyik=";
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
}

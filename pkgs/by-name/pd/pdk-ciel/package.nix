{
  lib,
  fetchFromGitHub,
  python3Packages,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "ciel";
  version = "3.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "fossi-foundation";
    repo = "ciel";
    tag = finalAttrs.version;
    hash = "sha256-IEeNYjmA7geiHCVzjadDzy77STbbWmie47HF63bqMqk=";
  };

  build-system = [ python3Packages.poetry-core ];

  # ciel pins click<8.5, still in 3.3.0, but only calls the public API of
  # click: its decorators, Context, the Parameter classes and their errors.
  pythonRelaxDeps = [ "click" ];

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

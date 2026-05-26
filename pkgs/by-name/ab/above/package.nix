{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "above";
  version = "2.8.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "caster0x00";
    repo = "Above";
    tag = "v${finalAttrs.version}";
    hash = "sha256-wyXWGfthzJeHZoJe4OKe9k2BIwLae/aOUtiJpT4SfHw=";
  };

  build-system = with python3.pkgs; [ setuptools ];

  dependencies = with python3.pkgs; [
    colorama
    scapy
  ];

  # Project has no tests
  doCheck = false;

  meta = {
    description = "Invisible network protocol sniffer";
    homepage = "https://github.com/caster0x00/Above";
    changelog = "https://github.com/caster0x00/Above/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "above";
  };
})

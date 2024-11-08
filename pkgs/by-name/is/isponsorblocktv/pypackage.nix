{
  buildPythonApplication,
  fetchFromGitHub,
  lib,
  hatchling,
  hatch-requirements-txt,
  aiohttp,
  appdirs,
  async-cache,
  pyytlounge,
  rich-click,
  rich,
  ssdp,
  textual-slider,
  textual,
  xmltodict,
  pythonRelaxDepsHook,
}:
buildPythonApplication rec {
  pname = "iSponsorBlockTV";
  version = "2.2.1";

  src = fetchFromGitHub {
    owner = "dmunozv04";
    repo = "iSponsorBlockTV";
    rev = "v${version}";
    hash = "sha256-v5NF6o+9IxusYNebs2a9fgHCHZNN9hHLQurujhmdsgU=";
  };

  pyproject = true;

  build-system = [
    hatchling
    hatch-requirements-txt
  ];

  dependencies = [
    aiohttp
    appdirs
    async-cache
    pyytlounge
    rich-click
    rich
    ssdp
    textual-slider
    textual
    xmltodict
  ];

  nativeBuildInputs = [ pythonRelaxDepsHook ];

  pythonRemoveDeps = [ "argparse" ];

  pythonRelaxDeps = [
    "aiohttp"
    "pyytlounge"
    "textual-slider"
    "textual"
  ];

  meta = {
    homepage = "https://github.com/dmunozv04/iSponsorBlockTV";
    description = "SponsorBlock client for all YouTube TV clients";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ lukegb ];
    mainProgram = "iSponsorBlockTV";
    platforms = lib.platforms.linux;
  };
}

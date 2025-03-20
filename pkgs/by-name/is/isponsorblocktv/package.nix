{
  fetchFromGitHub,
  lib,
  python3Packages,
}:

python3Packages.buildPythonApplication rec {
  pname = "isponsorblocktv";
  version = "2.3.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "dmunozv04";
    repo = "iSponsorBlockTV";
    tag = "v${version}";
    hash = "sha256-4HGhPUnors7T2UVZCLVIcGX63SRU3PZ1JQ+zf2ZV8/M=";
  };

  build-system = with python3Packages; [
    hatchling
    hatch-requirements-txt
  ];

  dependencies = with python3Packages; [
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

  # all dependencies are pinned to exact version numbers
  pythonRelaxDeps = true;

  meta = {
    homepage = "https://github.com/dmunozv04/iSponsorBlockTV";
    changelog = "https://github.com/dmunozv04/iSponsorBlockTV/releases/tag/${src.tag}";
    description = "SponsorBlock client for all YouTube TV clients";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ lukegb ];
    mainProgram = "iSponsorBlockTV";
    platforms = lib.platforms.linux;
  };
}

{
  fetchFromGitHub,
  lib,
  python3Packages,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "isponsorblocktv";
  version = "2.10.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "dmunozv04";
    repo = "iSponsorBlockTV";
    tag = "v${finalAttrs.version}";
    hash = "sha256-DxSrvUT1Ga8XwbPTZxMY4ZUBL4Tnhy9ZD0iuT+8NweE=";
  };

  build-system = with python3Packages; [
    hatchling
    hatch-requirements-txt
  ];

  dependencies = with python3Packages; [
    aiohttp
    appdirs
    async-cache
    pychromecast
    pyytlounge
    rich-click
    rich
    ssdp
    textual-slider
    textual
    xmltodict
    zeroconf
  ];

  # all dependencies are pinned to exact version numbers
  pythonRelaxDeps = true;

  meta = {
    homepage = "https://github.com/dmunozv04/iSponsorBlockTV";
    changelog = "https://github.com/dmunozv04/iSponsorBlockTV/releases/tag/${finalAttrs.src.tag}";
    description = "SponsorBlock client for all YouTube TV clients";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ lukegb ];
    mainProgram = "iSponsorBlockTV";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})

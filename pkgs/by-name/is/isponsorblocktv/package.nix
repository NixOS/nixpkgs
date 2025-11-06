{
  fetchFromGitHub,
  fetchpatch,
  lib,
  python3Packages,
}:

python3Packages.buildPythonApplication rec {
  pname = "isponsorblocktv";
  version = "2.6.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "dmunozv04";
    repo = "iSponsorBlockTV";
    tag = "v${version}";
    hash = "sha256-AGjLehhGYz8FyojSFmSYKLCkHAExtpQiukQnTNt1YoY=";
  };

  patches = [
    # Port iSponsorBlockTV to pyytlounge v3
    (fetchpatch {
      url = "https://github.com/ameertaweel/iSponsorBlockTV/commit/1809ca5a0d561bc9326a51e82118f290423ed3e6.patch";
      hash = "sha256-v5YXfKUPTzpZPIkVSQF2VUe9EvclAH+kJyiiyUEe/HM=";
    })
  ];

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
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
}

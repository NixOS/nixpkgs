{
  fetchFromGitHub,
  fetchpatch,
  lib,
  python3Packages,
}:

python3Packages.buildPythonApplication rec {
  pname = "isponsorblocktv";
  version = "2.5.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "dmunozv04";
    repo = "iSponsorBlockTV";
    tag = "v${version}";
    hash = "sha256-vxTEec5SMq5zcX70PiRD61aDPJUySuBG0TBQH5Qw8ow=";
  };

  patches = [
    # Port iSponsorBlockTV to pyytlounge v3
    (fetchpatch {
      url = "https://github.com/lukegb/iSponsorBlockTV/commit/3b50819fffbea23ef02f24726982a1b3313fa952.patch";
      hash = "sha256-2adgGE3rBnp+/z+2iblWCxO+6qV9RHx0dqTxv/kjDJU=";
    })

    # Update setup_wizard for Textual v3
    (fetchpatch {
      url = "https://github.com/lukegb/iSponsorBlockTV/commit/4a3874b781f796ad32e40fc871fee7c080716171.patch";
      hash = "sha256-kdfAaIuvQovst55sOmKv+zH/7JxN1JHI9aTF0c9fYAY=";
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

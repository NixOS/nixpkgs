{
  fetchFromGitHub,
  fetchpatch,
  lib,
  python3Packages,
}:

python3Packages.buildPythonApplication rec {
  pname = "isponsorblocktv";
  version = "2.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "dmunozv04";
    repo = "iSponsorBlockTV";
    tag = "v${version}";
    hash = "sha256-/lUs4EuifHKKyA8QiLsbqz0h6mxJpsFMjovpYE8+SxY=";
  };

  patches = [
    # Port iSponsorBlockTV to pyytlounge v3
    (fetchpatch {
      url = "https://github.com/lukegb/iSponsorBlockTV/commit/89b7b1c029cfbe3b5a481647cdd2d03dec5259ce.patch";
      hash = "sha256-ISMrNrfPTnEbb0lZbREf+kAniJopWx3FePMGFm4ycJY=";
    })

    # Update setup_wizard for Textual v3
    (fetchpatch {
      url = "https://github.com/lukegb/iSponsorBlockTV/commit/89dd1d65335689c73a78509689396888599bbe58.patch";
      hash = "sha256-hhWXcqNK3b3mXLCK7W0eXNWgP4lPSl6qgB59Fx8+yeA=";
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

{
  fetchFromGitHub,
  fetchpatch,
  lib,
  python3Packages,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "isponsorblocktv";
  version = "2.11.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "dmunozv04";
    repo = "iSponsorBlockTV";
    tag = "v${finalAttrs.version}";
    hash = "sha256-VbhkSrF18JluKAKqUsFKkjC0jdYsvjFotYr0aJ4BTKs=";
  };

  patches = [
    # Fix iSponsorBlockTV with async-cache 2.x - https://github.com/dmunozv04/iSponsorBlockTV/pull/505
    (fetchpatch {
      url = "https://github.com/lukegb/iSponsorBlockTV/commit/110ce5de788ccb262a323f743543e37af914f7fa.patch";
      hash = "sha256-AW9VwFBMDKo3pJCNc/r5b8vrqpcL1bV8jUl/z85x+jE=";
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

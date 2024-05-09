{ lib
, python3
, fetchFromGitHub
}:

python3.pkgs.buildPythonApplication rec {
  pname = "iSponsorBlockTV";
  version = "2.0.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "dmunozv04";
    repo = "iSponsorBlockTV";
    rev = "refs/tags/v${version}";
    hash = "sha256-Ovy5YLkhHxNLfn5ghTsN6lMs8EPfZvcPkIYS+BeB+zw=";
  };

  prePatch = ''
    sed -i /argparse/d requirements.txt
  '';

  pythonRelaxDeps = [
    "aiohttp"
    "pyytlounge"
    "rich"
    "textual"
  ];

  nativeBuildInputs = with python3.pkgs; [
    hatchling
    hatch-requirements-txt
    pythonRelaxDepsHook
  ];

  propagatedBuildInputs = with python3.pkgs; [
    aiohttp
    appdirs
    async-cache
    pyytlounge
    rich
    ssdp
    textual
    textual-slider
    xmltodict
  ];

  meta = with lib; {
    homepage = "https://github.com/dmunozv04/iSponsorBlockTV";
    changelog = "https://github.com/dmunozv04/iSponsorBlockTV/releases/tag/v${version}";
    description = "Skip sponsor segments in YouTube videos playing on a YouTube TV device";
    license = licenses.gpl3;
    maintainers = with maintainers; [ jloyet ];
    mainProgram = "iSponsorBlockTV";
  };
}

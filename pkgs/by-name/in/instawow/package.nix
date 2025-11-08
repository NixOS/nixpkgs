{
  lib,
  python3,
  fetchFromGitHub,
  plugins ? [ ],
}:

python3.pkgs.buildPythonApplication rec {
  pname = "instawow";
  version = "6.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "layday";
    repo = "instawow";
    tag = "v${version}";
    hash = "sha256-NFs8+BUXJEn64TDojG/xkH1O+zZurv0PWY+YDhu2mQY=";
  };

  extras = [ ]; # Disable GUI, most dependencies are not packaged.

  nativeBuildInputs = with python3.pkgs; [
    hatchling
    hatch-vcs
  ];
  propagatedBuildInputs =
    with python3.pkgs;
    [
      aiohttp
      aiohttp-client-cache
      attrs
      cattrs
      click
      diskcache
      iso8601
      loguru
      packaging
      pluggy
      prompt-toolkit
      rapidfuzz
      truststore
      typing-extensions
      yarl
    ]
    ++ plugins;

  meta = {
    homepage = "https://github.com/layday/instawow";
    description = "World of Warcraft add-on manager CLI and GUI";
    mainProgram = "instawow";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ seirl ];
  };
}

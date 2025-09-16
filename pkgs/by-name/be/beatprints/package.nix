{
  lib,
  python3Packages,
  fetchFromGitHub,
}:
python3Packages.buildPythonApplication rec {
  pname = "BeatPrints";
  version = "1.1.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "TrueMyst";
    repo = "BeatPrints";
    rev = "v${version}";
    hash = "sha256-7h2MbU6wPqcRhWijdMyd7sTf3UVNCX+5JUNytKr5/EM=";
  };

  build-system = with python3Packages; [
    poetry-core
  ];

  pythonRelaxDeps = [
    "Pillow"
    "rich"
  ];

  dependencies = with python3Packages; [
    requests
    pylette
    lrclibapi
    fonttools
    questionary
    rich
    toml
    pillow
    spotipy
  ];

  meta = {
    description = "Create eye-catching, Pinterest-style music posters effortlessly";
    longDescription = ''
      Create eye-catching, Pinterest-style music posters effortlessly. BeatPrints integrates with Spotify and LRClib API to help you design custom posters for your favorite tracks or albums. 🍀
    '';
    homepage = "https://beatprints.readthedocs.io";
    changelog = "https://github.com/TrueMyst/BeatPrints/releases/tag/v${version}";
    mainProgram = "beatprints";
    license = lib.licenses.cc-by-nc-sa-40;
    maintainers = with lib.maintainers; [ DataHearth ];
    platforms = lib.platforms.all;
  };
}

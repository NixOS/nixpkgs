{
  fetchFromGitHub,
  lib,
  python3Packages,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "redlist";
  version = "0-unstable-2026-01-30";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Laharah";
    repo = "redlist";
    rev = "3d465a12d79331eefde52351b441d8e0875f93e3";
    hash = "sha256-eROvTs4WCVeXE2+4FICC9Rl5bjIkf0E5sYvqCaskXEw=";
  };

  build-system = with python3Packages; [
    setuptools
  ];

  dependencies =
    with python3Packages;
    [
      aiohttp
      beets
      humanize
      confuse
      pynentry
      deluge-client
      cryptography
    ]
    ++ aiohttp.optional-dependencies.speedups;

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail '"pytest-runner"' ""
  '';

  meta = {
    description = "Convert Spotify playlists to local m3u's and fill the gaps";
    mainProgram = "redlist";
    homepage = "https://github.com/Laharah/redlist";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ lilahummel ];
  };
})

{
  lib,
  fetchFromGitHub,
  curl,
  flac,
  lame,
  mp3val,
  python3Packages,
  sox,
}:
let
  runtimeDeps = [
    curl
    flac
    lame
    mp3val
    sox
  ];
in
python3Packages.buildPythonApplication (finalAttrs: {
  pname = "smoked-salmon";
  version = "0.10.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "smokin-salmon";
    repo = "smoked-salmon";
    tag = finalAttrs.version;
    hash = "sha256-kgBTdQTWzGmKWsHjtazaVvQoTulyF5WNFPEUuoanCo4=";
  };

  # Upstream tends to use very narrow version constraints
  pythonRelaxDeps = true;

  # `build-system` requirements are seemingly not covered by pythonRelaxDeps
  postPatch = ''
    sed -i 's/requires = \["uv_build.*"\]/requires = ["uv_build"]/' pyproject.toml
  '';

  build-system = with python3Packages; [ uv-build ];

  dependencies =
    with python3Packages;
    [
      aiohttp
      aiohttp-jinja2
      aiolimiter
      anyio
      asyncclick
      av
      beautifulsoup4
      deluge-client
      humanfriendly
      jinja2
      msgspec
      musicbrainzngs
      mutagen
      numpy
      pillow
      platformdirs
      pycambia
      pyimgbox
      pyoxipng
      pyperclip
      qbittorrent-api
      requests
      send2trash
      tenacity
      torf
      tqdm
      transmission-rpc
      unidecode
    ]
    ++ aiohttp.optional-dependencies.speedups
    ++ beautifulsoup4.optional-dependencies.lxml
    ++ msgspec.optional-dependencies.toml;

  makeWrapperArgs = [
    "--suffix"
    "PATH"
    ":"
    (lib.makeBinPath finalAttrs.passthru.runtimeDeps)
  ];

  passthru = {
    inherit runtimeDeps;
  };

  meta = {
    description = "Toolkit for checking, editing and uploading music. Catered to Gazelle-based trackers";
    homepage = "https://github.com/smokin-salmon/smoked-salmon";
    license = with lib.licenses; [ asl20 ];
    mainProgram = "salmon";
    maintainers = with lib.maintainers; [
      ambroisie
      undefined-landmark
    ];
  };
})

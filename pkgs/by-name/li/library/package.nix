{
  lib,
  python3,
  fetchFromGitHub,
  gallery-dl,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "library";
  version = "2.9.036";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "chapmanjacobd";
    repo = "library";
    rev = "refs/tags/v${version}";
    hash = "sha256-kWL8MkXmKGu78ztuZuJbf3+iufMR2+br0I021ITVd5k=";
  };

  # project has similar problem
  # fix https://github.com/pypa/installer/issues/194
  patches = [ ./fix-duplicate.patch ];

  prePatch = ''
    # doesn't exists in source distribution
    sed -i "/^license.=\|^readme.=/d" pyproject.toml
  '';

  build-system = [ python3.pkgs.hatchling ];

  dependencies = with python3.pkgs; [
    beautifulsoup4
    feedparser
    ffmpeg-python
    ftfy
    gallery-dl
    humanize
    ipython
    lxml
    markdown
    mutagen
    natsort
    praw
    puremagic
    pysubs2
    python-dateutil
    python-mpv-jsonipc
    regex
    rich
    screeninfo
    sqlite-utils
    tabulate
    tinytag
    yt-dlp
  ];

  optional-dependencies = with python3.pkgs; {
    deluxe = [
      aiohttp
      annoy
      catt
      geopandas
      pyexiftool
      pymcdm
      pyvirtualdisplay
      scikit-learn
      selenium-wire
      subliminal
      xattr
    ];

    fat = [
      brotab
      ghostscript
      opencv-python
      orjson
      pypdf-table-extraction
      textract-py3
    ];
  };

  # lot of broken tests, need network, write, etc...
  doCheck = false;

  meta = {
    mainProgram = "library";
    description = "80+ CLI tools to build, browse, and blend your media library";
    homepage = "https://github.com/chapmanjacobd/library";
    changelog = "https://github.com/chapmanjacobd/library/releases/tag/v${version}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ vizid ];
  };
}

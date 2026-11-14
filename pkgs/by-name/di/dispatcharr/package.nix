{
  lib,
  writeText,
  fetchFromGitHub,
  nixosTests,
  python3,
  streamlink,
}:
let
  py = python3.override {
    self = py;
    packageOverrides = final: prev: {
      django = prev.django_5;
    };
  };
in
py.pkgs.buildPythonApplication rec {
  pname = "dispatcharr";
  version = "0.20.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Dispatcharr";
    repo = "Dispatcharr";
    tag = "v${version}";
    sha256 = "sha256-ZK65rJYgAyzS1lQdzlxrw31qfsjxcDi8xuDr+JWVlhw=";
  };

  build-system = with py.pkgs; [ hatchling ];

  dependencies = with py.pkgs; [
    celery
    channels
    channels-redis
    daphne
    django-celery-beat
    django-cors-headers
    django-filter
    django
    djangorestframework-simplejwt
    djangorestframework
    drf-spectacular
    gevent
    lxml
    m3u8
    pillow
    psutil
    psycopg2-binary
    python-vlc
    pytz
    rapidfuzz
    regex
    requests
    sentence-transformers
    streamlink
    torch
    tzlocal
    yt-dlp
  ];

  pythonRelaxDeps = [
    "psutil"
    "torch"
  ];
  pythonRemoveDeps = [
    "uwsgi" # only needed to launch app
  ];

  passthru = {
    tests = {
      inherit (nixosTests) dispatcharr; # TODO
    };
  };

  meta = {
    homepage = "https://github.com/Dispatcharr/Dispatcharr";
    description = "Your Ultimate IPTV & Stream Management Companion";
    license = lib.licenses.cc-by-nc-sa-40;
    maintainers = with lib.maintainers; [
      diogotcorreia
    ];
    platforms = py.meta.platforms;
  };
}

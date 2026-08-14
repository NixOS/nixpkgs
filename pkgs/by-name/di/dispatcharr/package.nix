{
  lib,
  fetchFromGitHub,
  fetchNpmDeps,
  jq,
  makeWrapper,
  moreutils,
  nodejs,
  npmHooks,
  nixosTests,
  python3Packages,
  ffmpeg,
  streamlink,
  uwsgi,
  vlc,
}:

let
  python = python3Packages.python.override {
    self = python;
    packageOverrides = final: prev: {
      django = prev.django_6;
    };
  };
  pythonPackages = python.pkgs;

  dependencies = with pythonPackages; [
    celery
    channels
    channels-redis
    daphne
    django
    django-celery-beat
    django-cors-headers
    django-db-geventpool
    django-filter
    django-redis
    djangorestframework
    djangorestframework-simplejwt
    drf-spectacular
    gevent
    lxml
    m3u8
    packaging
    pillow
    psutil
    psycopg
    python-vlc
    pytz
    rapidfuzz
    regex
    requests
    sentence-transformers
    torch
    tzlocal
    yt-dlp
  ];
in

pythonPackages.buildPythonApplication (finalAttrs: {
  pname = "dispatcharr";
  version = "0.28.2";
  pyproject = true;
  __structuredAttrs = true;

  inherit dependencies;

  src = fetchFromGitHub {
    owner = "Dispatcharr";
    repo = "Dispatcharr";
    tag = "v${finalAttrs.version}";
    hash = "sha256-rO3ZltWG29/fxFNiWzZP18yAMSUewm43mThQireTbtI=";
  };

  npmRoot = "frontend";

  # mpegts.js depends on webworkify-webpack through a GitHub shorthand
  # (`github:xqq/webworkify-webpack`). fetchNpmDeps cannot correctly handle git
  # deps without a lockfile, so replace the lockfile entry with the equivalent
  # GitHub tarball before the npm deps are fetched.
  postPatch = ''
    lockfile=frontend/package-lock.json
    if [ ! -f "$lockfile" ]; then
      lockfile=package-lock.json
    fi
    ${lib.getExe jq} '
      .packages["node_modules/webworkify-webpack"] |= {
        version: "2.1.5",
        resolved: "https://codeload.github.com/xqq/webworkify-webpack/tar.gz/24d1e719b4a6cac37a518b2bb10fe124527ef4ef",
        integrity: "sha512-DPqNW8CSRNB+5wfoia6e63A04AuOnkFPsBZMtEB2TMbQbBDcmrsBgwmppiCZZlvl1ve9i2p6f9ivCMtkz8q87A==",
        license: "MIT"
      }
      | .packages["node_modules/mpegts.js"].dependencies["webworkify-webpack"] = "2.1.5"
    ' "$lockfile" | sponge "$lockfile"
  '';

  npmDeps = fetchNpmDeps {
    inherit (finalAttrs) src postPatch;
    sourceRoot = "${finalAttrs.src.name}/${finalAttrs.npmRoot}";
    fetcherVersion = 2;
    nativeBuildInputs = [ moreutils ];
    hash = "sha256-cg/85fmhjSKk9j5LiQXGiK9hJpNfFVygxi3gBTu501Y=";
  };

  makeCacheWritable = true;

  nativeBuildInputs = [
    jq
    makeWrapper
    moreutils
    nodejs
    npmHooks.npmConfigHook
  ];

  preBuild = ''
    pushd frontend
    npm run build
    popd
  '';

  build-system = with pythonPackages; [
    hatchling
  ];

  pythonRemoveDeps = [
    # streamlink and uwsgi are runtime command-line tools, not Python imports
    "streamlink"
    "uwsgi"
  ];

  pythonRelaxDeps = [
    "channels"
    "channels-redis"
    "django"
    "django-celery-beat"
    "django-cors-headers"
    "djangorestframework-simplejwt"
    "drf-spectacular"
    "gevent"
    "lxml"
    "psutil"
    "rapidfuzz"
    "requests"
    "sentence-transformers"
    "torch"
  ];

  postInstall = ''
    # The frontend dist is served by Django from BASE_DIR / "frontend/dist".
    # BASE_DIR resolves to the site-packages directory that holds dispatcharr/,
    # apps/, and core/, so install the built assets next to them.
    mkdir -p $out/${pythonPackages.python.sitePackages}/frontend
    cp -r frontend/dist $out/${pythonPackages.python.sitePackages}/frontend/

    # manage.py and version.py live at the repo root and are not included in
    # the wheel. Install them at the site-packages root so they can be found at
    # runtime and so running manage.py does not put dispatcharr/ on sys.path.
    cp manage.py version.py $out/${pythonPackages.python.sitePackages}/
    chmod +x $out/${pythonPackages.python.sitePackages}/manage.py

    # Provide a manage.py wrapper that exposes the runtime command-line tools.
    makeWrapper $out/${pythonPackages.python.sitePackages}/manage.py $out/bin/dispatcharr-manage \
      --prefix PATH : "$out/bin:${
        lib.makeBinPath [
          ffmpeg
          streamlink
          uwsgi
          vlc
        ]
      }" \
      --prefix PYTHONPATH : "$PYTHONPATH"
  '';

  pythonImportsCheck = [
    "dispatcharr"
    "apps"
    "core"
  ];

  passthru = {
    inherit python;
    pythonPath = pythonPackages.makePythonPath dependencies;
    tests = {
      inherit (nixosTests) dispatcharr;
    };
  };

  meta = {
    description = "IPTV stream, M3U/EPG, and HDHomeRun management companion";
    homepage = "https://github.com/Dispatcharr/Dispatcharr";
    changelog = "https://github.com/Dispatcharr/Dispatcharr/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [
      diogotcorreia
      staticdev
    ];
    platforms = lib.platforms.linux;
  };
})

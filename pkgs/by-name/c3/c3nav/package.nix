{
  lib,
  fetchFromGitHub,
  gettext,
  python3Packages,
}:
let
  pythonPackages = python3Packages.overrideScope (
    final: prev: {
      django = prev.django_6;
    }
  );

  dependencies = with pythonPackages; [
    # https://github.com/c3nav/c3nav/blob/39c3/docker/Dockerfile#L77-L87
    # src/requirements/production.txt
    django
    django-bootstrap3
    django-compressor
    django-cors-headers
    csscompressor
    django-ninja
    pydantic-extra-types
    types-shapely
    django-pydantic-field
    django-filter
    django-environ
    shapely
    pybind11
    meshpy
    rtree
    celery
    requests
    pillow
    qrcode
    matplotlib
    scipy
    django-libsass
    channels
    daphne
    pyzstd
    pyproj
    # src/requirements/htmlmin.txt
    django-htmlmin
    # src/requirements/postgres.txt
    psycopg2
    # src/requirements/redis.txt
    redis
    hiredis
    channels-redis
    # src/requirements/memcached.txt
    pylibmc
    # src/requirements/rsvg-pygobject.txt
    pygobject3
    pycairo
    # src/requirements/sentry.txt
    sentry-sdk
    # src/requirements/metrics.txt
    django-prometheus
    # src/requirements/uwu.txt
    uwuipy
    polib
    # src/requirements/sso.txt
    social-auth-app-django
    social-auth-core
    # src/requirements/server-asgi.txt
    starlette
    uvicorn
    gunicorn
  ];
in
pythonPackages.buildPythonApplication (finalAttrs: {
  pname = "c3nav";
  version = "39c3";
  format = "other";

  src = fetchFromGitHub {
    owner = "c3nav";
    repo = "c3nav";
    tag = finalAttrs.version;
    hash = "sha256-OOF635TkCUYsBQyfvo3twnyV25O3eyqs6Nd1mgSF1rg=";
  };

  patches = [
    ./fix-read-only-assignment.diff
  ];

  __structuredAttrs = true;

  nativeBuildInputs = [
    gettext
    (pythonPackages.python.withPackages (_: dependencies))
  ];

  inherit dependencies;

  buildPhase = ''
    pushd src
    # https://github.com/c3nav/c3nav/blob/39c3/docker/Dockerfile#L112-L116
    python manage.py makemessages --ignore "site-packages" -l en_UW
    python genuwu.py
    python manage.py compilemessages --ignore "site-packages"
    popd
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/${pythonPackages.python.sitePackages}/
    cp -r src/c3nav $out/${pythonPackages.python.sitePackages}/c3nav
    cp src/manage.py $out/bin/c3nav-manage

    pushd $out/${pythonPackages.python.sitePackages}/c3nav
    PYTHONPATH=$PYTHONPATH:$PWD/.. python $out/bin/c3nav-manage collectstatic -l --no-input
    PYTHONPATH=$PYTHONPATH:$PWD/.. python $out/bin/c3nav-manage compress
    rm -r ../data
    popd

    runHook postInstall
  '';

  passthru = {
    inherit pythonPackages;
  };

  meta = {
    description = "Indoor navigation for the Chaos Communication Congress and other events";
    homepage = "https://c3nav.de/";
    downloadPage = "https://github.com/c3nav/c3nav/";
    license = lib.licenses.asl20;
    mainProgram = "c3nav-manage";
    maintainers = with lib.maintainers; [ SuperSandro2000 ];
  };
})

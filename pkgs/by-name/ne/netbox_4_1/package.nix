{
  lib,
  fetchFromGitHub,
  fetchpatch,
  python3,
  plugins ? _ps: [ ],
  nixosTests,
}:
let
  py = python3.override {
    packageOverrides = _final: prev: { django = prev.django_5; };
  };

  extraBuildInputs = plugins py.pkgs;
in
py.pkgs.buildPythonApplication rec {
  pname = "netbox";
  version = "4.1.11";

  format = "other";

  src = fetchFromGitHub {
    owner = "netbox-community";
    repo = "netbox";
    tag = "v${version}";
    hash = "sha256-Nd8HWXn7v0llmg934KGtS5+Tj2RvBhJDuXEvB2Pg3nQ=";
  };

  patches = [
    ./custom-static-root.patch

    # Rebase of PR 17620 "Upgrade to Django 5.1"
    # https://github.com/netbox-community/netbox/pull/17620
    (fetchpatch {
      url = "https://github.com/netbox-community/netbox/commit/cda9e0525dc850ddd82bf46762a64607bf97df83.patch";
      hash = "sha256-iJiz5f926Np1k4c9DpfPe0HefJy1CH6c0wjwBIt1vWQ=";
    })
  ];

  propagatedBuildInputs =
    (
      with py.pkgs;
      [
        django
        django-cors-headers
        django-debug-toolbar
        django-filter
        django-graphiql-debug-toolbar
        django-htmx
        django-mptt
        django-pglocks
        django-prometheus
        django-redis
        django-rq
        django-tables2
        django-taggit
        django-timezone-field
        djangorestframework
        drf-spectacular
        drf-spectacular-sidecar
        feedparser
        jinja2
        markdown
        netaddr
        nh3
        pillow
        psycopg
        psycopg.optional-dependencies.c
        psycopg.optional-dependencies.pool
        pyyaml
        requests
        social-auth-core
        social-auth-app-django
        strawberry-graphql
        strawberry-django
        svgwrite
        tablib

        # Optional dependencies, kept here for backward compatibility

        # for the S3 data source backend
        boto3
        # for Git data source backend
        dulwich
        # for error reporting
        sentry-sdk
      ]
      ++ social-auth-core.passthru.optional-dependencies.openidconnect
    )
    ++ extraBuildInputs;

  buildInputs = with py.pkgs; [
    mkdocs-material
    mkdocs-material-extensions
    mkdocstrings
    mkdocstrings-python
  ];

  nativeBuildInputs = [ py.pkgs.mkdocs ];

  postBuild = ''
    PYTHONPATH=$PYTHONPATH:netbox/
    python -m mkdocs build
  '';

  installPhase = ''
    mkdir -p $out/opt/netbox
    cp -r . $out/opt/netbox
    chmod +x $out/opt/netbox/netbox/manage.py
    makeWrapper $out/opt/netbox/netbox/manage.py $out/bin/netbox \
      --prefix PYTHONPATH : "$PYTHONPATH"
  '';

  passthru = {
    python = python3;
    # PYTHONPATH of all dependencies used by the package
    pythonPath = py.pkgs.makePythonPath propagatedBuildInputs;
    inherit (py.pkgs) gunicorn;
    tests = {
      netbox = nixosTests.netbox_4_1;
      inherit (nixosTests) netbox-upgrade;
    };
  };

  meta = {
    homepage = "https://github.com/netbox-community/netbox";
    description = "IP address management (IPAM) and data center infrastructure management (DCIM) tool";
    mainProgram = "netbox";
    license = lib.licenses.asl20;
    knownVulnerabilities = [
      "Netbox version ${version} is EOL; please upgrade by following the current release notes instructions."
    ];
    maintainers = with lib.maintainers; [
      minijackson
      raitobezarius
    ];
  };
}

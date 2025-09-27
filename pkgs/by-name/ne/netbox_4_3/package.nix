{
  lib,
  fetchFromGitHub,
  python3,
  plugins ? _ps: [ ],
  nixosTests,
  nix-update-script,
}:
let
  py = python3.override {
    self = py;
    packageOverrides = _final: prev: { django = prev.django_5_2; };
  };

  extraBuildInputs = plugins py.pkgs;
in
py.pkgs.buildPythonApplication rec {
  pname = "netbox";
  version = "4.3.7";
  pyproject = false;

  src = fetchFromGitHub {
    owner = "netbox-community";
    repo = "netbox";
    tag = "v${version}";
    hash = "sha256-xVOP1D3C12M0M8oTrCA0M17NLuor+46UwiaKymSAVJM=";
  };

  patches = [
    ./custom-static-root.patch
  ];

  dependencies =
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
        django-storages
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
      ++ psycopg.optional-dependencies.c
      ++ psycopg.optional-dependencies.pool
      ++ social-auth-core.optional-dependencies.openidconnect
    )
    ++ extraBuildInputs;

  nativeBuildInputs = with py.pkgs; [
    mkdocs-material
    mkdocs-material-extensions
    mkdocstrings
    mkdocstrings-python
  ];

  postBuild = ''
    PYTHONPATH=$PYTHONPATH:netbox/
    ${py.interpreter} -m mkdocs build
  '';

  installPhase = ''
    mkdir -p $out/opt/netbox
    cp -r . $out/opt/netbox
    chmod +x $out/opt/netbox/netbox/manage.py
    makeWrapper $out/opt/netbox/netbox/manage.py $out/bin/netbox \
      --prefix PYTHONPATH : "$PYTHONPATH"
  '';

  passthru = {
    python = py;
    # PYTHONPATH of all dependencies used by the package
    pythonPath = py.pkgs.makePythonPath dependencies;
    inherit (py.pkgs) gunicorn;
    tests = {
      netbox = nixosTests.netbox_4_3;
      inherit (nixosTests) netbox-upgrade;
    };
    updateScript = nix-update-script { };
  };

  meta = {
    homepage = "https://github.com/netbox-community/netbox";
    changelog = "https://github.com/netbox-community/netbox/blob/${src.tag}/docs/release-notes/version-${lib.versions.majorMinor version}.md";
    description = "IP address management (IPAM) and data center infrastructure management (DCIM) tool";
    mainProgram = "netbox";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      minijackson
      raitobezarius
      transcaffeine
    ];
  };
}

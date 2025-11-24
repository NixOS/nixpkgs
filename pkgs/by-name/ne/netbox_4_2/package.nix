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
    packageOverrides = _final: prev: { django = prev.django_5; };
  };

  extraBuildInputs = plugins py.pkgs;
in
py.pkgs.buildPythonApplication rec {
  pname = "netbox";
  version = "4.2.9";

  format = "other";

  src = fetchFromGitHub {
    owner = "netbox-community";
    repo = "netbox";
    tag = "v${version}";
    hash = "sha256-uVe4YTZoxRMBfvItFa9SMHu4AaVvygfAg9GDB115TFc=";
  };

  patches = [
    ./custom-static-root.patch
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
      netbox = nixosTests.netbox_4_2;
      inherit (nixosTests) netbox-upgrade;
    };
    updateScript = nix-update-script { };
  };

  meta = {
    homepage = "https://github.com/netbox-community/netbox";
    description = "IP address management (IPAM) and data center infrastructure management (DCIM) tool";
    mainProgram = "netbox";
    license = lib.licenses.asl20;
    knownVulnerabilities = [
      "Netbox Version ${version} is EOL; please upgrade by following the current release notes instructions"
    ];
    maintainers = with lib.maintainers; [
      minijackson
      raitobezarius
    ];
  };
}

{
  python3,
  fetchFromGitHub,
  nixosTests,
  lib,

  plugins ? ps: [ ],
}:

let
  python = python3.override {
    packageOverrides = final: prev: {
      django = prev.django_5;
    };
  };
in
python.pkgs.buildPythonApplication (finalAttrs: {
  pname = "peering-manager";
  version = "1.10.3";

  src = fetchFromGitHub {
    owner = "peering-manager";
    repo = "peering-manager";
    tag = "v${finalAttrs.version}";
    sha256 = "sha256-SRXQIbSCnIH1JUJTpF754Jx/B+xzgKhXfNGbhaMyCYQ=";
  };

  pyproject = false;

  propagatedBuildInputs =
    with python.pkgs;
    [
      django
      django-debug-toolbar
      django-filter
      django-postgresql-netfields
      django-prometheus
      django-redis
      django-rq
      django-tables2
      django-taggit
      djangorestframework
      drf-spectacular
      drf-spectacular-sidecar
      dulwich
      jinja2
      markdown
      napalm
      packaging
      psycopg2
      pyixapi
      pynetbox
      pyyaml
      requests
      social-auth-app-django
      pytz
      tzdata
    ]
    ++ plugins python.pkgs;

  buildPhase = ''
    runHook preBuild
    cp peering_manager/configuration{.example,}.py
    python3 manage.py collectstatic --no-input
    rm -f peering_manager/configuration.py
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/opt/peering-manager
    cp -r . $out/opt/peering-manager
    chmod +x $out/opt/peering-manager/manage.py
    makeWrapper $out/opt/peering-manager/manage.py $out/bin/peering-manager \
      --prefix PYTHONPATH : "$PYTHONPATH"
    runHook postInstall
  '';

  passthru = {
    # PYTHONPATH of all dependencies used by the package
    inherit python;
    pythonPath = python.pkgs.makePythonPath finalAttrs.propagatedBuildInputs;

    tests = {
      inherit (nixosTests) peering-manager;
    };
  };

  meta = {
    homepage = "https://peering-manager.net/";
    license = lib.licenses.asl20;
    description = "BGP sessions management tool";
    mainProgram = "peering-manager";
    maintainers = with lib.maintainers; [ yureka-wdz ];
    platforms = lib.platforms.linux;
  };
})

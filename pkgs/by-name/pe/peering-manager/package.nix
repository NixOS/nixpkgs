{
  python3,
  fetchFromGitHub,
  nixosTests,
  lib,

  plugins ? ps: [ ],
}:

python3.pkgs.buildPythonApplication rec {
  pname = "peering-manager";
  version = "1.8.3";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "refs/tags/v${version}";
    sha256 = "sha256-UV1zSX9C9y5faOBUQ7bfj2DT6ffhMW28MIT7SaYjMgw=";
  };

  format = "other";

  patches = [
    # Fix compatibility with pyixapi 0.2.3
    # https://github.com/peering-manager/peering-manager/commit/ee558ff66e467412942559a8a92252e3fc009920
    ./fix-pyixapi-0.2.3-compatibility.patch
  ];

  propagatedBuildInputs =
    with python3.pkgs;
    [
      django
      djangorestframework
      django-redis
      django-debug-toolbar
      django-filter
      django-postgresql-netfields
      django-prometheus
      django-rq
      django-tables2
      django-taggit
      drf-spectacular
      drf-spectacular-sidecar
      jinja2
      markdown
      napalm
      packaging
      psycopg2
      pyixapi
      pynetbox
      pyyaml
      requests
      tzdata
    ]
    ++ plugins python3.pkgs;

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
    python = python3;
    pythonPath = python3.pkgs.makePythonPath propagatedBuildInputs;

    tests = {
      inherit (nixosTests) peering-manager;
    };
  };

  meta = with lib; {
    homepage = "https://peering-manager.net/";
    license = licenses.asl20;
    description = "BGP sessions management tool";
    mainProgram = "peering-manager";
    maintainers = teams.wdz.members;
    platforms = platforms.linux;
  };
}

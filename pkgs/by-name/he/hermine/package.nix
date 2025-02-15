{ lib
, python3
, fetchFromGitLab
, buildNpmPackage
, makeBinaryWrapper
}:

let
  version = "0.2.1";
  src = fetchFromGitLab {
    owner = "hermine-project";
    repo = "hermine";
    rev = "v${version}";
    hash = "sha256-k4pF6z5jv3WMUuv5NzbexF9yX8Q4SB+cytQ+9h6Z49M=";
  };

  hermine-frontend = buildNpmPackage {
    pname = "hermine-frontend";
    inherit src version;

    installPhase = ''
      runHook preInstall
      cp -ar hermine $out/
      runHook postInstall
    '';

    npmDepsHash = "sha256-q7iup3GHfhkKo1bEpMqmybXKvTnOf/p+nT5BfG5ACqw=";
  };
in
python3.pkgs.buildPythonApplication rec {
  inherit version src;
  pname = "hermine";
  pyproject = true;

  # Poetry assumes your package contains a package with the same name as
  # `tool.poetry.name` located in the root of your project. If this is not the
  # case, populate `tool.poetry.packages` to specify your packages and their
  # locations. (see https://python-poetry.org/docs/basic-usage/#project-setup)
  # TODO: Submit a patch upstream to fix this
  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "hermine-project" "hermine" \
      --replace-fail psycopg2-binary psycopg2

    cp -ar ${hermine-frontend} hermine/hermine/dist/
  '';

  nativeBuildInputs = with python3.pkgs; [
    makeBinaryWrapper
    poetry-core
    pythonRelaxDepsHook
  ];

  pythonRelaxDeps = true;

  propagatedBuildInputs = [
    (python3.withPackages (p: with p; [
      django
      django-filter
      django-silk
      djangorestframework
      drf-nested-routers
      drf-yasg
      junit-xml
      odfpy
      packageurl-python
      psycopg2
      setuptools # for pkg_resources
      social-auth-app-django
      spdx-tools
      tqdm
    ]))
  ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/lib/
    cp -r hermine $out/lib/
    cp -r ${hermine-frontend}/* $out/lib/hermine/
    cp docker/config.py $out/lib/hermine/hermine/
    chmod +x $out/lib/hermine/manage.py
    makeWrapper $out/lib/hermine/manage.py $out/bin/hermine \
      --prefix PYTHONPATH : "${python3.pkgs.makePythonPath propagatedBuildInputs}"
    runHook postInstall
  '';

  # There are no tests
  doCheck = false;

  meta = {
    description = "Hermine is an Open Source application to manage your SBOMs of Open Source components, their licenses and their respective obligations";
    homepage = "https://gitlab.com/hermine-project/hermine";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [ drupol ];
  };
}

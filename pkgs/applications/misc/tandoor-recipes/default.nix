{ callPackage
, nixosTests
, python3
, fetchFromGitHub
}:
let
  python = python3.override {
    packageOverrides = self: super: {
      validators = super.validators.overridePythonAttrs (_: rec {
        version = "0.20.0";
        src = fetchFromGitHub {
          owner = "python-validators";
          repo = "validators";
          rev = version;
          hash = "sha256-ZnLyTHlsrXthGnaPzlV2ga/UTm5SSEHLTwC/tobiPak=";
        };
        propagatedBuildInputs = [ super.decorator super.six ];
      });

      djangorestframework = super.djangorestframework.overridePythonAttrs (oldAttrs: rec {
        version = "3.14.0";
        src = oldAttrs.src.override {
          rev = version;
          hash = "sha256-Fnj0n3NS3SetOlwSmGkLE979vNJnYE6i6xwVBslpNz4=";
        };
        nativeCheckInputs = with super; [
          pytest7CheckHook
          pytest-django
        ];
      });
    };
  };

  common = callPackage ./common.nix { };

  frontend = callPackage ./frontend.nix { };
in
python.pkgs.pythonPackages.buildPythonPackage rec {
  pname = "tandoor-recipes";

  inherit (common) version src;

  format = "other";

  patches = [
    ./pytest-xdist.patch # adapt pytest.ini the use $NIX_BUILD_CORES
  ];

  postPatch = ''
    substituteInPlace pytest.ini --subst-var NIX_BUILD_CORES
  '';

  propagatedBuildInputs = with python.pkgs; [
    aiohttp
    beautifulsoup4
    bleach
    bleach-allowlist
    boto3
    cryptography
    django
    django-allauth
    django-annoying
    django-auth-ldap
    django-cleanup
    django-cors-headers
    django-crispy-forms
    django-crispy-bootstrap4
    django-hcaptcha
    django-js-reverse
    django-oauth-toolkit
    django-prometheus
    django-scopes
    django-storages
    django-tables2
    django-webpack-loader
    django-treebeard
    djangorestframework
    drf-writable-nested
    gunicorn
    icalendar
    jinja2
    lxml
    markdown
    microdata
    pillow
    psycopg2
    pyppeteer
    python-dotenv
    pytube
    pyyaml
    recipe-scrapers
    requests
    six
    uritemplate
    validators
    webdavclient3
    whitenoise
  ];

  configurePhase = ''
    runHook preConfigure

    ln -sf ${frontend}/ cookbook/static/vue
    cp ${frontend}/webpack-stats.json vue/

    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild

    # Disable debug logging
    export DEBUG=0
    # Avoid dependency on django debug toolbar
    export DEBUG_TOOLBAR=0

    # See https://github.com/TandoorRecipes/recipes/issues/2043
    mkdir cookbook/static/themes/maps/
    touch cookbook/static/themes/maps/style.min.css.map
    touch cookbook/static/themes/bootstrap.min.css.map
    touch cookbook/static/css/bootstrap-vue.min.css.map

    ${python.pythonOnBuildForHost.interpreter} manage.py collectstatic_js_reverse
    ${python.pythonOnBuildForHost.interpreter} manage.py collectstatic

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib
    cp -r . $out/lib/tandoor-recipes
    chmod +x $out/lib/tandoor-recipes/manage.py
    makeWrapper $out/lib/tandoor-recipes/manage.py $out/bin/tandoor-recipes \
      --prefix PYTHONPATH : "$PYTHONPATH"

    # usually copied during frontend build (see vue.config.js)
    cp vue/src/sw.js $out/lib/tandoor-recipes/cookbook/templates/

    runHook postInstall
  '';

  nativeCheckInputs = with python.pkgs; [
    mock
    pytestCheckHook
    pytest-asyncio
    pytest-cov
    pytest-django
    pytest-factoryboy
    pytest-html
    pytest-xdist
  ];

  # flaky
  disabledTests = [
    "test_search_count"
    "test_url_import_regex_replace"
    "test_delete"
  ];

  passthru = {
    inherit frontend python;

    updateScript = ./update.sh;

    tests = {
      inherit (nixosTests) tandoor-recipes;
    };
  };

  meta = common.meta // {
    description = ''
      Application for managing recipes, planning meals, building shopping lists
      and much much more!
    '';
    mainProgram = "tandoor-recipes";
  };
}

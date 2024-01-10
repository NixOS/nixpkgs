{ callPackage
, nixosTests
, python3
, fetchFromGitHub
, fetchpatch
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
    # Allow setting MEDIA_ROOT through environment variable
    ./media-root.patch
    # https://github.com/TandoorRecipes/recipes/pull/2706
    (fetchpatch {
      url = "https://github.com/TandoorRecipes/recipes/commit/702c1d67d3b2d13cf471bf9daa1d2ef0f1837dec.patch";
      hash = "sha256-6vmtYs6b0d38Ojxxc2I7oxqpkIlyRVlhzURBOTO2VlQ=";
    })
  ];

  propagatedBuildInputs = with python.pkgs; [
    beautifulsoup4
    bleach
    bleach-allowlist
    boto3
    cryptography
    django
    django-allauth
    django-annoying
    django-auth-ldap
    django-autocomplete-light
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
    pytestCheckHook
    pytest-django
    pytest-factoryboy
  ];

  # flaky
  disabledTests = [
    "test_search_count"
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
  };
}

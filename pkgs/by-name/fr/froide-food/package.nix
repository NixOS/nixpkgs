{
  lib,
  python3Packages,
  fetchFromGitHub,
  makeBinaryWrapper,
  froide,
  nixosTests,
  fetchpatch,
  froide-govplan,
  gettext,
  gdal,
  fetchPnpmDeps,
  pnpm_10,
}:
let
  inherit (froide) python;
  # python = python3Packages.python.override {
  #   packageOverrides = self: super: {
  #     django = super.django_5.override { withGdal = true; };
  #     django_fix = self.django;
  #   };
  # };
in
python.pkgs.buildPythonApplication (finalAttrs: {
  pname = "froide-food";
  version = "0-unstable-2026-02-02";
  pyproject = true;

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "okfde";
    repo = "froide-food";
    # No tagged release yet
    rev = "29b2817b7545a4d06110d40cfd3ab16f3383f58e";
    hash = "sha256-EgucdiMh0i9dIpQ+mq+3aCkOIGNgzLmkJnS2a3mp2Yc=";
  };

  patches = [
    ./add_manage_py.patch
    ./add_settings_py.patch
  ];

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    pnpm = pnpm_10;
    fetcherVersion = 3;
    hash = "sha256-5AxyrK91Dm58b/32KJmVysno4WizXBG71IluwS5JT2Q=";
  };

  build-system = [ python.pkgs.setuptools ];

  nativeBuildInputs = [
    gettext
    makeBinaryWrapper
  ];

  build-inputs = [ gdal ];

  dependencies = with python.pkgs; [
    django-amenities
    # django_fix
    geopy
    python-dateutil

    requests

    celery
    django-configurations
    dj-database-url
    psycopg

    # Patch froide to avoid loading account module
    (toPythonModule (
      froide.overridePythonAttrs (prev: {
        patches = prev.patches ++ [ ./froide_avoid_loading_account_module.patch ];
        doCheck = false;
      })
    ))

    django-filingcabinet
    django-cms
    djangocms-alias
    django-sekizai
    django-cors-headers
  ];

  #env.DJANGO_SETTINGS_MODULE = "froide_food.settings";
  #env.DJANGO_CONFIGURATION = "Development";

  #preBuild = ''
  #  ${python.interpreter} -m django compilemessages
  #'';

  postInstall = ''
    chmod +x manage.py
    cp manage.py $out/${python.sitePackages}/froide_food/
    cp -r frontend $out/${python.sitePackages}/froide_food/
    makeWrapper $out/${python.sitePackages}/froide_food/manage.py $out/bin/froide-food \
      --prefix PYTHONPATH : ${finalAttrs.passthru.pythonPath}:$out/${python.sitePackages}
  '';

  passthru = {
    tests = {
      inherit (nixosTests) froide-food;
    };
    inherit python;
    pythonPath = "${python.pkgs.makePythonPath finalAttrs.passthru.dependencies}";
  };

  meta = {
    description = "Government planner and basis of FragDenStaat.de Koalitionstracker";
    homepage = "https://github.com/okfde/froide-food";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.onny ];
    mainProgram = "froide-food";
  };

})

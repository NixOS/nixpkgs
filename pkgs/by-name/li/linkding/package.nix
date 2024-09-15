{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  fetchNpmDeps,
  nix-update-script,
  nixosTests,
  nodejs,
  npmHooks,
  pkgs,
  playwright-driver,
  python3Packages,
  uwsgi,
}:
let
  pname = "linkding";
  version = "1.36.0";

  src = fetchFromGitHub {
    owner = "sissbruecker";
    repo = "linkding";
    tag = "v${version}";
    hash = "sha256-AePxd7uc1DvMwzhWluYIzXnFDlH/kiWNjBMzj/p68Mk=";
  };
  npmDeps = fetchNpmDeps {
    inherit src;
    name = "${pname}-npm-deps";
    hash = "sha256-BA7PurUcB5glgaBIpuZLPRSg3GDdi4CLniUjoa/32yc=";
  };

in
python3Packages.buildPythonApplication {
  inherit
    npmDeps
    pname
    src
    version
    ;

  build-system = [
    python3Packages.setuptools
  ];

  dependencies = [
    python3Packages.asgiref
    python3Packages.beautifulsoup4
    python3Packages.bleach
    python3Packages.bleach-allowlist
    python3Packages.certifi
    python3Packages.cffi
    python3Packages.charset-normalizer
    python3Packages.click
    python3Packages.confusable-homoglyphs
    python3Packages.cryptography
    python3Packages.django
    python3Packages.django-registration
    python3Packages.django-widget-tweaks
    python3Packages.djangorestframework
    python3Packages.huey
    python3Packages.idna
    python3Packages.josepy
    python3Packages.markdown
    python3Packages.mozilla-django-oidc
    python3Packages.psycopg2
    python3Packages.pycparser
    python3Packages.pyopenssl
    python3Packages.python-dateutil
    python3Packages.requests
    python3Packages.setuptools
    python3Packages.six
    python3Packages.soupsieve
    python3Packages.sqlparse
    python3Packages.supervisor
    python3Packages.urllib3
    python3Packages.waybackpy
    python3Packages.webencodings
    uwsgi
  ];

  nativeBuildInputs = [
    nodejs
    npmHooks.npmConfigHook
  ];

  buildPhase = ''
    runHook preBuild

    # Based on $src/docker/alpine.Dockerfile
    # node-build stage
    npm run build

    mkdir --parents data/{assets,favicons,previews} dist

    npm run build

    python manage.py collectstatic

    cp --no-preserve=all --recursive . "$out/"

    runHook postBuild
  '';

  nativeCheckInputs = [
    python3Packages.django-debug-toolbar
    python3Packages.playwright
  ];

  checkPhase = ''
    runHook preCheck

    python manage.py test bookmarks.tests

    export PLAYWRIGHT_BROWSERS_PATH=${playwright-driver.browsers}
    python manage.py test bookmarks.e2e --pattern="e2e_test_*.py"

    runHook postCheck
  '';

  passthru = {
    tests = {
      nixos = nixosTests.linkding;
    };
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Self-hosted bookmark manager";
    homepage = "https://github.com/sissbruecker/linkding";
    changelog = "https://github.com/sissbruecker/linkding/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.l0b0 ];
  };
}

{
  fetchFromGitHub,
  fetchNpmDeps,
  lib,
  nix-update-script,
  nixosTests,
  nodejs,
  npmHooks,
  pkgs,
  python3Packages,
}:
let
  pname = "linkding";
  version = "1.36.0";

  src = fetchFromGitHub {
    owner = "sissbruecker";
    repo = "linkding";
    rev = "refs/tags/v${version}";
    hash = "sha256-AePxd7uc1DvMwzhWluYIzXnFDlH/kiWNjBMzj/p68Mk=";
  };
in
python3Packages.buildPythonApplication {
  inherit pname src version;

  npmDeps = fetchNpmDeps {
    inherit src;
    name = "${pname}-npm-deps";
    hash = "sha256-BA7PurUcB5glgaBIpuZLPRSg3GDdi4CLniUjoa/32yc=";
  };

  nativeBuildInputs = [
    nodejs
    npmHooks.npmConfigHook
    python3Packages.beautifulsoup4
    python3Packages.bleach-allowlist
    python3Packages.django-widget-tweaks
    python3Packages.djangorestframework
    python3Packages.huey
    python3Packages.markdown
    python3Packages.mozilla-django-oidc
    python3Packages.python-dateutil
    python3Packages.waybackpy
  ];

  build-system = [
    python3Packages.setuptools
  ];

  buildPhase = ''
    runHook preBuild

    mkdir --parents data/{favicons,previews} dist
    npm run build
    python manage.py collectstatic

    runHook postBuild
  '';

  nativeCheckInputs = [
    python3Packages.django-debug-toolbar
    python3Packages.playwright
  ];

  checkPhase = ''
    python manage.py test bookmarks.tests

    export PLAYWRIGHT_BROWSERS_PATH=${pkgs.playwright-driver.browsers}
    export PLAYWRIGHT_SKIP_VALIDATE_HOST_REQUIREMENTS=true
    python manage.py test bookmarks.e2e --pattern="e2e_test_*.py"
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
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ l0b0 ];
  };
}

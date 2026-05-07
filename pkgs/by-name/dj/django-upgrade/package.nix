{
  lib,
  fetchFromGitHub,
  python3Packages,
  versionCheckHook,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "django-upgrade";
  version = "1.30.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "adamchainz";
    repo = "django-upgrade";
    tag = finalAttrs.version;
    hash = "sha256-IiGwYq6TTNiNIx1jrzQlLiULWNZlam7onJJGFFJ/hVM=";
  };

  build-system = [ python3Packages.setuptools ];

  dependencies = [ python3Packages.tokenize-rt ];

  nativeCheckInputs = [
    python3Packages.pytestCheckHook
    versionCheckHook
  ];

  pythonImportsCheck = [ "django_upgrade" ];

  meta = {
    description = "Automatically upgrade your Django projects";
    homepage = "https://github.com/adamchainz/django-upgrade";
    changelog = "https://github.com/adamchainz/django-upgrade/blob/${finalAttrs.version}/docs/changelog.rst";
    mainProgram = "django-upgrade";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.kalekseev ];
  };
})

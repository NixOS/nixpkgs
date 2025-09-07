{
  lib,
  fetchFromGitHub,
  python3Packages,
  versionCheckHook,
}:

python3Packages.buildPythonApplication rec {
  pname = "django-upgrade";
  version = "1.27.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "adamchainz";
    repo = "django-upgrade";
    tag = version;
    hash = "sha256-QvjXDnXQuRqnpWbnmqeDL3gNFiYIlG87QQVXsYc99YQ=";
  };

  build-system = [ python3Packages.setuptools ];

  dependencies = [ python3Packages.tokenize-rt ];

  nativeCheckInputs = [
    python3Packages.pytestCheckHook
    versionCheckHook
  ];

  versionCheckProgramArg = "--version";

  pythonImportsCheck = [ "django_upgrade" ];

  meta = {
    description = "Automatically upgrade your Django projects";
    homepage = "https://github.com/adamchainz/django-upgrade";
    changelog = "https://github.com/adamchainz/django-upgrade/blob/${version}/docs/changelog.rst";
    mainProgram = "django-upgrade";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.kalekseev ];
  };
}

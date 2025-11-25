{
  fetchFromGitHub,
  lib,

  buildPythonPackage,
  setuptools,
}:

buildPythonPackage {
  pname = "ixxy-email-logger";
  version = "0-unstable-2025-08-28";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Ixxy-Open-Source";
    repo = "ixxy-email-logger";
    rev = "da4671eebfdd8782b3c274bb095230065bd3ca59";
    hash = "sha256-OSecCqHpMx+xSSz5cdydFXIDRuzFxfwLG6tnwZF+gAg=";
  };

  build-system = [
    setuptools
  ];

  pythonImportsCheck = [
    "email_logger"
  ];

  meta = {
    description = "Email logger";
    branch = "feature/django4";
    homepage = "https://github.com/Ixxy-Open-Source/ixxy-email-logger";
    license = lib.licenses.asl20;
    teams = with lib.teams; [ ngi ];
  };
}

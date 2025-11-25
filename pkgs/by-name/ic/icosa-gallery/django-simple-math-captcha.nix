{
  fetchPypi,
  lib,

  buildPythonPackage,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "django-simple-math-captcha";
  version = "2.0.1";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-U2OkdU2tRhsiMkZoAy4IQi3Jpe9hHTWVD9Pakqh9GtM=";
  };

  build-system = [
    setuptools
  ];

  pythonImportsCheck = [
    "simplemathcaptcha"
  ];

  meta = {
    description = "Math field/widget captcha for Django forms";
    homepage = "https://github.com/alsoicode/django-simple-math-captcha";
    license = lib.licenses.asl20;
    teams = with lib.teams; [ ngi ];
  };
})

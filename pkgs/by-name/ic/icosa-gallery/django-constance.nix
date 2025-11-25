{
  fetchFromGitHub,
  lib,

  buildPythonPackage,
  django,
  redis,
  setuptools,
  setuptools-scm,
  wheel,
}:

buildPythonPackage (finalAttrs: {
  pname = "django-constance";
  version = "4.3.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jazzband";
    repo = "django-constance";
    tag = finalAttrs.version;
    hash = "sha256-fs4P4lk6K5eceQ82o7/mW1JLgfuTR0k4799X0VWnG54=";
  };

  build-system = [
    setuptools
    setuptools-scm
    wheel
  ];

  dependencies = [
    django
  ];

  optional-dependencies = {
    redis = [
      redis
    ];
  };

  pythonImportsCheck = [
    "constance"
  ];

  meta = {
    description = "Dynamic Django settings";
    homepage = "https://github.com/jazzband/django-constance";
    license = lib.licenses.bsd3;
    teams = with lib.teams; [ ngi ];
  };
})

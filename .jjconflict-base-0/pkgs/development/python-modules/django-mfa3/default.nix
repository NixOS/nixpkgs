{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  django,
  setuptools,
  pyotp,
  fido2,
  qrcode,
  python,
}:

buildPythonPackage rec {
  pname = "django-mfa3";
  version = "0.15.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "xi";
    repo = "django-mfa3";
    tag = version;
    hash = "sha256-HcurgGSzPnKVRpL9NVq0vkCmYDvj/HoWYVbnIrK5pSI=";
  };

  build-system = [ setuptools ];

  dependencies = [
    django
    pyotp
    fido2
    qrcode
  ];

  # qrcode 8.0 not supported yet
  # See https://github.com/xi/django-mfa3/pull/14
  pythonRelaxDeps = [ "qrcode" ];

  checkPhase = ''
    ${python.interpreter} -m django test --settings tests.settings
  '';

  meta = {
    description = "Multi factor authentication for Django";
    homepage = "https://github.com/xi/django-mfa3";
    changelog = "https://github.com/xi/django-mfa3/blob/${src.rev}/CHANGES.md";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.onny ];
  };
}

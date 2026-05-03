{
  lib,
  fetchFromGitHub,
  python3,
}:
python3.pkgs.buildPythonPackage (finalAttrs: {
  pname = "django-jsonform";
  version = "2.23.2";
  pyproject = true;
  build-system = with python3.pkgs; [ setuptools ];
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "bhch";
    repo = "django-jsonform";
    tag = "v${finalAttrs.version}";
    hash = "sha256-OyVaaMldvAPqyML7eWMk8FtML5ssPtaDWGlqqx9fSkM==";
  };

  propagatedBuildInputs = with python3.pkgs; [ django ];
  pythonImportsCheck = [ "django_jsonform" ];

  meta = {
    description = "A better, user-friendly JSON editing form field for Django admin. Also supports Postgres ArrayField.";
    homepage = "https://github.com/bhch/django-jsonform";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ kiara ];
  };
})

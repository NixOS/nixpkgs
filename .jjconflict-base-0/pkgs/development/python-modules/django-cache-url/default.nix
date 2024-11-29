{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
}:

buildPythonPackage rec {
  version = "3.2.2";
  format = "setuptools";
  pname = "django-cache-url";

  src = fetchFromGitHub {
    owner = "epicserve";
    repo = "django-cache-url";
    rev = "v${version}";
    sha256 = "0fxma2w6zl3cfl6wnynmlmp8snks67ffz4jcq4qmdc65xv1l204l";
  };

  postPatch = ''
    # disable coverage tests
    sed -i '/--cov/d' setup.cfg
  '';

  nativeCheckInputs = [ pytestCheckHook ];

  meta = with lib; {
    homepage = "https://github.com/epicserve/django-cache-url";
    description = "Use Cache URLs in your Django application";
    license = licenses.mit;
    maintainers = [ ];
  };
}

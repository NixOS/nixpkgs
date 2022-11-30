{ lib
, stdenv
, buildPythonApplication
, fetchFromGitHub
, pythonOlder
, pytestCheckHook
# requirements/local.txt
, django-debug-toolbar
, django_silk
, ipython
, towncrier
# requirements/base.txt
, beautifulsoup4
, bibtexparser
, dj-database-url
, django
, django-compressor
, django-crispy-forms
, pillow
, psycopg2
, python-decouple
, python-docx
, pytz
, requests
, xlwt
# requirements/production.txt
, gunicorn
, sentry-sdk
# requirements/tests.txt
, factory_boy
, flake8
, isort
}:

let parsifal = buildPythonApplication rec {
  pname = "parsifal";
  version = "2.2.0";
  disabled = pythonOlder "3.9";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "vitorfs";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-2Vhjv7eN+iTg7vsfscbuutw2Bai2P/HXWfvSMOxsO/0=";
  };

  postPatch = ''
    substituteInPlace requirements/local.txt \
      --replace "==" ">=" \
      --replace "git+git://github.com/jazzband/django-silk.git#egg=django-silk" "django-silk"

    substituteInPlace requirements/base.txt \
      --replace "==" ">="

    substituteInPlace requirements/production.txt \
      --replace "==" ">="

    substituteInPlace requirements/tests.txt \
      --replace "==" ">="
  '';

  propagatedBuildInputs = [
    # requirements/local.txt
    django-debug-toolbar
    django_silk
    ipython
    towncrier

    # requirements/base.txt
    beautifulsoup4
    bibtexparser
    dj-database-url
    django
    django-compressor
    django-crispy-forms
    pillow
    psycopg2
    python-decouple
    python-docx
    pytz
    requests
    xlwt

    # requirements/production.txt
    gunicorn
    sentry-sdk
  ];

  checkInputs = [
    factory_boy
    flake8
    isort
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "parsifal"
  ];

  # disabledTests = [
  # ];

  doCheck = false;

  passthru.tests = {
    default = parsifal.overridePythonAttrs (oldAttrs: {
      doCheck = true;
    });
  };

  meta = with lib; {
    description = "Systematic literature review tool based on Kitchenham's software engineering guidelines";
    homepage = "https://parsif.al/";
    changelog = "https://github.com/vitorfs/parsifal/releases";
    license = licenses.mit;
    maintainers = with maintainers; [
      yuu
    ];
  };
}; in parsifal

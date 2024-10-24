{
  python3,
  fetchFromGitHub,
  makeWrapper,
}:
let

  python = python3.override {
    packageOverrides = self: super: {
      django = super.django_5.override { withGdal = true; };
    };
  };

in
python.pkgs.buildPythonApplication rec {
  pname = "froide";
  version = "1";

  src = fetchFromGitHub {
    owner = "okfde";
    repo = "froide";
    rev = "a78a4054f9f37b0a5109a6d8cfbbda742f86a8ca";
    hash = "sha256-gtOssbsVf3nG+pmLPgvh4685vHh2x+jlXiTjU+JhQa8=";
  };

  pyproject = true;

  build-system = [ python.pkgs.setuptools ];

  nativeBuildInputs = [ makeWrapper ];

  dependencies = with python.pkgs; [
    python-slugify
    django-parler
    drf-spectacular
    pygtail
    phonenumbers
    icalendar
    easy-thumbnails
    python-magic
    django-filter
    django-taggit
    requests
    django-configurations
    django-storages
    dj-database-url
    celery
    celery-singleton
    markdown
    geoip2
    django-elasticsearch-dsl
    django-filingcabinet
    django-crossdomainmedia
    python-mimeparse
    djangorestframework-jsonp
    djangorestframework-csv
  ];
}

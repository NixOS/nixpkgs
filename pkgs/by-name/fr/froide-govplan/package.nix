{
  python3,
  fetchFromGitHub,
  makeWrapper,
  froide,
  gdal,
}:

let

  python = python3.override {
    packageOverrides = self: super: {
      django = super.django_5.override { withGdal = true; };
    };
  };

in
python.pkgs.buildPythonApplication rec {
  pname = "froide-govplan";
  version = "1";

  src = fetchFromGitHub {
    owner = "okfde";
    repo = "froide-govplan";
    rev = "eb0908dea9ecc64b23ca8a2bc550fcb1a400e3f1";
    hash = "sha256-4lBxIvNRr7/Jf2fV8Aaz9plOOK0tArIzyUfHDZTuE9c=";
  };

  pyproject = true;

  build-system = [ python.pkgs.setuptools ];

  build-inputs = [ gdal ];

  nativeBuildInputs = [ makeWrapper ];

  dependencies = with python.pkgs; [
    bleach
    django-admin-sortable2
    django-cms
    django-filer
    django-mfa3
    django-oauth-toolkit
    django-tinymce
    psycopg
    froide
    django-mptt
    django-sekizai
    django-treebeard
  ];

  postInstall = ''
    cp manage.py $out/${python.sitePackages}/froide_govplan/
    cp -r project $out/${python.sitePackages}/froide_govplan/
    makeWrapper $out/${python.sitePackages}/froide_govplan/manage.py $out/bin/froide-govplan \
      --prefix PYTHONPATH : "$PYTHONPATH" \
      --set GDAL_LIBRARY_PATH "${gdal}/lib/libgdal.so"
  '';
}

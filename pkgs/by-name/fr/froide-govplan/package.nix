{
  lib,
  python3Packages,
  fetchFromGitHub,
  makeBinaryWrapper,
  froide,
  gdal,
  geos,
  nixosTests,
  fetchpatch,
  froide-govplan,
  gettext,
}:
let
  python = python3Packages.python.override {
    packageOverrides = self: super: {
      django = super.django.override { withGdal = true; };
    };
  };
in
python.pkgs.buildPythonApplication rec {
  pname = "froide-govplan";
  version = "0-unstable-2025-01-27";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "okfde";
    repo = "froide-govplan";
    # No tagged release yet
    # https://github.com/okfde/froide-govplan/issues/15
    rev = "f1763807614b8c54a9214359a2a1e442ca58cb6d";
    hash = "sha256-Y7/qjhu3y9E55ZDmDf5HUk9JVcUTvi9KnqavqwNixTM=";
  };

  patches = [
    # Add missing oauth2_provider app
    # https://github.com/okfde/froide-govplan/pull/17
    (fetchpatch {
      url = "https://github.com/okfde/froide-govplan/commit/bc388b693ebc7656fc7917511048a47b68e119fe.patch";
      hash = "sha256-StIyN3gFKd/fld14s03fsV6fmWinSRWINUyRRBzqVco=";
      name = "add_oauth2_provider_app.patch";
    })
    # Enable automatic image cropping for filer
    # https://github.com/okfde/froide-govplan/pull/19
    (fetchpatch {
      url = "https://github.com/okfde/froide-govplan/commit/d5db02f3bbc501929a901e964147a0ed2f974f41.patch";
      hash = "sha256-jf6e84fd2kQIPER2HGmZNkbtl067311xdNJRU+iFVXM=";
      name = "filer_enable_automatic_cropping.patch";
    })
    # Add support for reading SECRET_KEY_FILE
    # https://github.com/okfde/froide-govplan/pull/21
    (fetchpatch {
      url = "https://github.com/okfde/froide-govplan/commit/39dc381ed6c4afcbbaea616f0e8f44d5eeb96ec2.patch";
      hash = "sha256-PxBtB6VupK4QJiWKKlTmub+7tfi6nAHWe29lxpNgoVk=";
      name = "add_secret_key_file_support.patch";
    })

    # Patch settings.py to source additional settings from the NixOS module
    ./load_extra_settings.patch
  ];

  build-system = [ python.pkgs.setuptools ];

  nativeBuildInputs = [
    gettext
    makeBinaryWrapper
  ];

  build-inputs = [ gdal ];

  dependencies = with python.pkgs; [
    bleach
    django-admin-sortable2
    django-cms
    django-filer
    django-mfa3
    django-mptt
    django-oauth-toolkit
    django-sekizai
    django-tinymce
    django-treebeard
    djangocms-alias
    # Downgrade to last working version
    (toPythonModule (
      froide.overridePythonAttrs (prev: {
        nativeBuildInputs = [ makeBinaryWrapper ];
        postBuild = "";
        doCheck = false;
        pnpmDeps = null;
        src = prev.src.override {
          rev = "a78a4054f9f37b0a5109a6d8cfbbda742f86a8ca";
          hash = "sha256-gtOssbsVf3nG+pmLPgvh4685vHh2x+jlXiTjU+JhQa8=";
        };
      })
    ))
    psycopg
  ];

  preBuild = "${python.interpreter} -m django compilemessages";

  postInstall = ''
    cp manage.py $out/${python.sitePackages}/froide_govplan/
    cp -r project $out/${python.sitePackages}/froide_govplan/
    cp -r froide_govplan/locale $out/${python.sitePackages}/froide_govplan/
    makeWrapper $out/${python.sitePackages}/froide_govplan/manage.py $out/bin/froide-govplan \
      --prefix PYTHONPATH : "$PYTHONPATH" \
      --set GDAL_LIBRARY_PATH "${gdal}/lib/libgdal.so" \
      --set GEOS_LIBRARY_PATH "${geos}/lib/libgeos_c.so"
  '';

  passthru = {
    tests = {
      inherit (nixosTests) froide-govplan;
    };
    python = python;
    pythonPath = "${python.pkgs.makePythonPath dependencies}:${froide-govplan}/${python.sitePackages}";
  };

  meta = {
    description = "Government planner and basis of FragDenStaat.de Koalitionstracker";
    homepage = "https://github.com/okfde/froide-govplan";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.onny ];
    mainProgram = "froide-govplan";
  };

}

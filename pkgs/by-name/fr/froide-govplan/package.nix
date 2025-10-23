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
      django_5 = super.django_5.override { withGdal = true; };
      django = super.django_5;
    };
  };
in
python.pkgs.buildPythonApplication rec {
  pname = "froide-govplan";
  version = "0-unstable-2025-07-14";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "okfde";
    repo = "froide-govplan";
    # No tagged release yet
    # https://github.com/okfde/froide-govplan/issues/15
    rev = "7d304ae0e34e44f3bc34dce2b7e5f3c62bd64299";
    hash = "sha256-/0KASLvKWgXBrhYkPeOkWfovNLAuKB5m0PVkQvC6w7s=";
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
    # Patch froide to avoid loading account module
    (toPythonModule (
      froide.overridePythonAttrs (prev: {
        patches = prev.patches ++ [ ./froide_avoid_loading_account_module.patch ];
        doCheck = false;
      })
    ))
    nh3
    psycopg
  ];

  preBuild = "${python.interpreter} -m django compilemessages";

  postInstall = ''
    cp manage.py $out/${python.sitePackages}/froide_govplan/
    cp -r project $out/${python.sitePackages}/froide_govplan/
    cp -r froide_govplan/locale $out/${python.sitePackages}/froide_govplan/
    makeWrapper $out/${python.sitePackages}/froide_govplan/manage.py $out/bin/froide-govplan \
      --prefix PYTHONPATH : ${passthru.pythonPath}:$out/${python.sitePackages} \
      --set GDAL_LIBRARY_PATH "${gdal}/lib/libgdal.so" \
      --set GEOS_LIBRARY_PATH "${geos}/lib/libgeos_c.so"
  '';

  passthru = {
    tests = {
      inherit (nixosTests) froide-govplan;
    };
    inherit python;
    pythonPath = "${python.pkgs.makePythonPath dependencies}";
  };

  meta = {
    description = "Government planner and basis of FragDenStaat.de Koalitionstracker";
    homepage = "https://github.com/okfde/froide-govplan";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.onny ];
    mainProgram = "froide-govplan";
  };

}

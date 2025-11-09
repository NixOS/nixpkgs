{
  lib,
  python3Packages,
  fetchFromGitHub,
  makeBinaryWrapper,
  froide,
  nixosTests,
  fetchpatch,
  froide-govplan,
  gettext,
  gdal,
}:
let
  python = python3Packages.python.override {
    packageOverrides = self: super: {
      django = super.django_5.override { withGdal = true; };
      django_fix = self.django;
    };
  };
in
python.pkgs.buildPythonApplication rec {
  pname = "froide-food";
  version = "0-unstable-2025-09-18";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "okfde";
    repo = "froide-food";
    # No tagged release yet
    rev = "a70bfc44e56e5d2338dc4ba3111ed376152d550b";
    hash = "sha256-yzlT0iEcmUMQwlNj/MyW/GavLupGEMk2e0JrUV/z9g0=";
  };

  patches = [
    ./add_manage_py.patch
    #./add_settings_py.patch
  ];

  build-system = [ python.pkgs.setuptools ];

  nativeBuildInputs = [
    gettext
    makeBinaryWrapper
  ];

  build-inputs = [ gdal ];

  dependencies = with python.pkgs; [
    django-amenities
    django_fix
    geopy
    psycopg2
    python-dateutil

    requests
  ];

  #env.DJANGO_SETTINGS_MODULE = "froide_food.settings";
  #env.DJANGO_CONFIGURATION = "Development";

  #preBuild = ''
  #  ${python.interpreter} -m django compilemessages
  #'';

  postInstall = ''
    chmod +x manage.py
    cp manage.py $out/${python.sitePackages}/froide_food/
    cp -r frontend $out/${python.sitePackages}/froide_food/
    makeWrapper $out/${python.sitePackages}/froide_food/manage.py $out/bin/froide-food \
      --prefix PYTHONPATH : ${passthru.pythonPath}:$out/${python.sitePackages}
  '';

  passthru = {
    tests = {
      inherit (nixosTests) froide-food;
    };
    inherit python;
    pythonPath = "${python.pkgs.makePythonPath dependencies}";
  };

  meta = {
    description = "Government planner and basis of FragDenStaat.de Koalitionstracker";
    homepage = "https://github.com/okfde/froide-food";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.onny ];
    mainProgram = "froide-food";
  };

}

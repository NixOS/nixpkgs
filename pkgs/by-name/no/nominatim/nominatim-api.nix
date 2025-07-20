{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  hatchling,
  psycopg,
  pyicu,
  python-dotenv,
  pyyaml,
  sqlalchemy,
}:

buildPythonPackage rec {
  pname = "nominatim";
  version = "5.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "osm-search";
    repo = "Nominatim";
    tag = "v${version}";
    hash = "sha256-eMCXXPrUZvM4ju0mi1+f+LXhThCCCEH+HDz6lurw+Jo=";
  };

  postPatch = ''
    # pyproject.toml tool.hatch.build.targets.sdist.exclude is not properly
    # excluding config.py file.
    # Fix FileExistsError: File already exists: ... nominatim_api/config.py
    rm src/nominatim_api/config.py

    # Change to package directory
    cd packaging/nominatim-api
  '';

  build-system = [
    hatchling
  ];

  dependencies = [
    psycopg
    pyicu
    python-dotenv
    pyyaml
    sqlalchemy
  ];

  # Fails on: ModuleNotFoundError: No module named 'nominatim_db'
  # pythonImportsCheck = [ "nominatim_api" ];

  meta = {
    description = "Search engine for OpenStreetMap data (API module)";
    homepage = "https://nominatim.org/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ mausch ];
    teams = with lib.teams; [
      geospatial
      ngi
    ];
  };
}

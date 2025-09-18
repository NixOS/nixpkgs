{
  lib,
  fetchFromGitHub,
  fetchurl,

  osm2pgsql,
  python3Packages,

  nominatim, # required for testVersion
  nixosTests,
  testers,
}:

let
  countryGrid = fetchurl {
    # Nominatim-db needs https://www.nominatim.org/data/country_grid.sql.gz
    # but it's not a very good URL for pinning
    url = "https://web.archive.org/web/20220323041006/https://nominatim.org/data/country_grid.sql.gz";
    hash = "sha256-/mY5Oq9WF0klXOv0xh0TqEJeMmuM5QQJ2IxANRZd4Ek=";
  };
in
python3Packages.buildPythonApplication rec {
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
    # Fix: FileExistsError: File already exists: ... nominatim_db/paths.py
    # pyproject.toml tool.hatch.build.targets.sdist.exclude is not properly
    # excluding paths.py file.
    rm src/nominatim_db/paths.py

    # Install country_osm_grid.sql.gz required for data import
    cp ${countryGrid} ./data/country_osm_grid.sql.gz

    # Change to package directory
    cd packaging/nominatim-db
  '';

  build-system = with python3Packages; [
    hatchling
  ];

  dependencies = with python3Packages; [
    nominatim-api

    jinja2
    psutil
    psycopg
    pyicu
    python-dotenv
    pyyaml
  ];

  propagatedBuildInputs = [
    osm2pgsql
  ];

  pythonImportsCheck = [ "nominatim_db" ];

  passthru.tests = {
    version = testers.testVersion { package = nominatim; };
    inherit (nixosTests) nominatim;
  };

  meta = {
    description = "Search engine for OpenStreetMap data (DB, CLI)";
    homepage = "https://nominatim.org/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ mausch ];
    teams = with lib.teams; [
      geospatial
      ngi
    ];
    mainProgram = "nominatim";
  };
}

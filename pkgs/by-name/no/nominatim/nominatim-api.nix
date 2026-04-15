{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  hatchling,
  async-timeout,
  psycopg,
  pyicu,
  python-dotenv,
  pyyaml,
  sqlalchemy,
}:

buildPythonPackage (finalAttrs: {
  pname = "nominatim";
  version = "5.3.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "osm-search";
    repo = "Nominatim";
    tag = "v${finalAttrs.version}";
    hash = "sha256-3WU8n121JbFFZTntcKG6t0x2mC1AzI97q/fMe/UTGTs=";
  };

  postPatch = ''
    # pyproject.toml tool.hatch.build.targets.sdist.exclude is not properly
    # excluding config.py file.
    # Fix FileExistsError: File already exists: ... nominatim_api/config.py
    rm src/nominatim_api/config.py

    # Change to package directory
    cd packaging/nominatim-api
  '';

  build-system = [ hatchling ];

  dependencies = [
    async-timeout
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
})

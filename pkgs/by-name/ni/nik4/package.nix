{
  lib,
  fetchFromGitHub,

  nixosTests,
  python3Packages,
}:

python3Packages.buildPythonPackage rec {
  pname = "nik4";
  version = "1.8";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Zverik";
    repo = "Nik4";
    tag = "v${version}";
    hash = "sha256-ICNy+H1N8YY/5P4gCX/laAn+G2JNQOKhvh4fsgcM0kM=";
  };

  build-system = with python3Packages; [ setuptools ];

  dependencies = with python3Packages; [
    pycairo
    python-mapnik
  ];

  strictDeps = true;

  passthru.tests = {
    inherit (nixosTests) nik4;
  };

  meta = {
    changelog = "https://github.com/Zverik/Nik4/releases/tag/v${version}";
    description = "Mapnik to image export";
    homepage = "https://github.com/Zverik/Nik4";
    license = lib.licenses.wtfpl;
    mainProgram = "nik4.py";
    maintainers = lib.teams.geospatial.members ++ (with lib.maintainers; [ Luflosi ]);
    platforms = lib.platforms.linux;
  };
}

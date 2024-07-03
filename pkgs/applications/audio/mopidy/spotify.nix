{
  lib,
  fetchFromGitHub,
  pythonPackages,
  mopidy,
  nix-update-script,
}:

pythonPackages.buildPythonApplication {
  pname = "mopidy-spotify";
  version = "4.1.1-unstable-2024-02-27";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mopidy";
    repo = "mopidy-spotify";
    rev = "112d4abbb3f5b6477dab796f2824fa42196bfa0a";
    hash = "sha256-RkXDzAbOOll3uCNZ2mFRnjqMkT/NkXOGjywLRTC9i60=";
  };

  build-system = [ pythonPackages.setuptools ];

  dependencies = [
    mopidy
    pythonPackages.responses
  ];

  nativeCheckInputs = [ pythonPackages.pytestCheckHook ];

  pythonImportsCheck = [ "mopidy_spotify" ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Mopidy extension for playing music from Spotify";
    homepage = "https://github.com/mopidy/mopidy-spotify";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ getchoo ];
  };
}

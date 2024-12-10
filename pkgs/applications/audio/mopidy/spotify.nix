{
  lib,
  fetchFromGitHub,
  pythonPackages,
  mopidy,
  unstableGitUpdater,
}:

pythonPackages.buildPythonApplication rec {
  pname = "mopidy-spotify";
  version = "4.1.1-unstable-2024-02-27";

  src = fetchFromGitHub {
    owner = "mopidy";
    repo = "mopidy-spotify";
    rev = "112d4abbb3f5b6477dab796f2824fa42196bfa0a";
    hash = "sha256-RkXDzAbOOll3uCNZ2mFRnjqMkT/NkXOGjywLRTC9i60=";
  };

  propagatedBuildInputs = [
    mopidy
    pythonPackages.responses
  ];

  nativeBuildInputs = [
    pythonPackages.pytestCheckHook
  ];

  pythonImportsCheck = [ "mopidy_spotify" ];

  passthru.updateScript = unstableGitUpdater {
    tagPrefix = "v";
  };

  meta = with lib; {
    homepage = "https://github.com/mopidy/mopidy-spotify";
    description = "Mopidy extension for playing music from Spotify";
    license = licenses.asl20;
    maintainers = with maintainers; [ lilyinstarlight ];
  };
}

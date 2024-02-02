{ lib, fetchFromGitHub, pythonPackages, mopidy, unstableGitUpdater }:

pythonPackages.buildPythonApplication rec {
  pname = "mopidy-spotify";
  version = "unstable-2024-01-02";

  src = fetchFromGitHub {
    owner = "mopidy";
    repo = "mopidy-spotify";
    rev = "ede555c4c6e5f198659a979b85c69294d148c8f3";
    hash = "sha256-G2SPzMAfJK3mOUJ+odmaugMoAyIAU1J6OXk25J/oXI0=";
  };

  propagatedBuildInputs = [
    mopidy
    pythonPackages.responses
  ];

  nativeBuildInputs = [
    pythonPackages.pytestCheckHook
  ];

  pythonImportsCheck = [ "mopidy_spotify" ];

  passthru.updateScript = unstableGitUpdater { };

  meta = with lib; {
    homepage = "https://github.com/mopidy/mopidy-spotify";
    description = "Mopidy extension for playing music from Spotify";
    license = licenses.asl20;
    maintainers = with maintainers; [ lilyinstarlight ];
  };
}

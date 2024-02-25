{ lib, fetchFromGitHub, pythonPackages, mopidy, unstableGitUpdater }:

pythonPackages.buildPythonApplication rec {
  pname = "mopidy-spotify";
  version = "unstable-2024-02-11";

  src = fetchFromGitHub {
    owner = "mopidy";
    repo = "mopidy-spotify";
    rev = "fc6ffb3bbbae9224316e2a888db08ef56608966a";
    hash = "sha256-V1SW8OyuBKLbUoQ4O5iiS4mq3MOXidcVKpiw125vxjQ=";
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

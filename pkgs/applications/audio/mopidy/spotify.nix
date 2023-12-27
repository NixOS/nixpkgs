{ lib, fetchFromGitHub, pythonPackages, mopidy, unstableGitUpdater }:

pythonPackages.buildPythonApplication rec {
  pname = "mopidy-spotify";
  version = "unstable-2023-12-20";

  src = fetchFromGitHub {
    owner = "mopidy";
    repo = "mopidy-spotify";
    rev = "2d26b54900bc1fdb974f571036f7101f6e6a3846";
    hash = "sha256-T5lWgjDhYCUe/mWAM1SFHzWbxyJ7US1fn0sPTVi/s2s=";
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

{ lib, fetchFromGitHub, pythonPackages, mopidy, unstableGitUpdater }:

pythonPackages.buildPythonApplication rec {
  pname = "mopidy-spotify";
  version = "unstable-2023-11-01";

  src = fetchFromGitHub {
    owner = "mopidy";
    repo = "mopidy-spotify";
    rev = "48faaaa2642647b0152231798b46ccd9631694f5";
    hash = "sha256-RwkUdcbDU7/ndVnPteG/iXB2dloljvCHQlvPk4tacuA=";
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

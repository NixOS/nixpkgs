{ lib
, annexremote
, buildPythonApplication
, drivelib
, fetchPypi
, gitpython
, humanfriendly
, tenacity
}:

buildPythonApplication rec {
  pname = "git-annex-remote-googledrive";
  version = "1.3.2";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-IRufry6NGtK4W7k1TEKA/mMcOec452Dzc7T953Zjkmc=";
  };

  propagatedBuildInputs = [
    annexremote
    drivelib
    gitpython
    tenacity
    humanfriendly
  ];

  # while git-annex does come with a testremote command that *could* be used,
  # testing this special remote obviously depends on authenticating with google
  doCheck = false;

  pythonImportsCheck = [
    "git_annex_remote_googledrive"
  ];

  meta = with lib; {
    description = "Git-annex special remote for Google Drive";
    homepage = "https://pypi.org/project/git-annex-remote-googledrive/";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ gravndal ];
    mainProgram = "git-annex-remote-googledrive";
  };
}

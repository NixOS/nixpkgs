{ lib
, buildPythonApplication
, fetchPypi
, annexremote
, drivelib
, GitPython
, tenacity
, humanfriendly
}:

buildPythonApplication rec {
  pname = "git-annex-remote-googledrive";
  version = "1.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "118w0fyy6pck8hyj925ym6ak0xxqhkaq2vharnpl9b97nab4mqg8";
  };

  propagatedBuildInputs = [ annexremote drivelib GitPython tenacity humanfriendly ];

  # while git-annex does come with a testremote command that *could* be used,
  # testing this special remote obviously depends on authenticating with google
  doCheck = false;

  pythonImportsCheck = [ "git_annex_remote_googledrive" ];

  meta = with lib; {
    description = "A git-annex special remote for Google Drive";
    homepage = "https://pypi.org/project/git-annex-remote-googledrive/";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ gravndal ];
  };
}

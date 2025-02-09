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
    sha256 = "0rwjcdvfgzdlfgrn1rrqwwwiqqzyh114qddrbfwd46ld5spry6r1";
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
    description = "A git-annex special remote for Google Drive";
    homepage = "https://pypi.org/project/git-annex-remote-googledrive/";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ gravndal ];
    mainProgram = "git-annex-remote-googledrive";
  };
}

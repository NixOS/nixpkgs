{
  lib,
  annexremote,
  buildPythonApplication,
  drivelib,
  fetchPypi,
  gitpython,
  humanfriendly,
  tenacity,
  setuptools,
  distutils,
}:

buildPythonApplication rec {
  pname = "git-annex-remote-googledrive";
  version = "1.3.2";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    sha256 = "0rwjcdvfgzdlfgrn1rrqwwwiqqzyh114qddrbfwd46ld5spry6r1";
  };

  build-system = [ setuptools ];

  propagatedBuildInputs = [
    annexremote
    drivelib
    gitpython
    tenacity
    humanfriendly
    distutils
  ];

  # while git-annex does come with a testremote command that *could* be used,
  # testing this special remote obviously depends on authenticating with google
  doCheck = false;

  pythonImportsCheck = [
    "git_annex_remote_googledrive"
  ];

  meta = with lib; {
    description = "Git-annex special remote for Google Drive";
    homepage = "https://github.com/Lykos153/git-annex-remote-googledrive";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ gravndal ];
    mainProgram = "git-annex-remote-googledrive";
  };
}

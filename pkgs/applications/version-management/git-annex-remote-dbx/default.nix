{
  lib,
  buildPythonApplication,
  fetchPypi,
  dropbox,
  annexremote,
  humanfriendly,
}:

buildPythonApplication rec {
  pname = "git-annex-remote-dbx";
  version = "1.0.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5b6f8025ed1e9877f06882ddbd81f701a8e094647ab97595e2afc09016835a7c";
  };

  propagatedBuildInputs = [
    dropbox
    annexremote
    humanfriendly
  ];

  meta = with lib; {
    description = "A git-annex special remote for Dropbox";
    homepage = "https://pypi.org/project/git-annex-remote-dbx/";
    license = licenses.mit;
    mainProgram = "git-annex-remote-dbx";
  };
}

{ lib
, buildPythonApplication
, fetchPypi
, dropbox
, annexremote
, humanfriendly
}:

buildPythonApplication rec {
  pname = "git-annex-remote-dbx";
  version = "1.0.3";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-W2+AJe0emHfwaILdvYH3AajglGR6uXWV4q/AkBaDWnw=";
  };

  propagatedBuildInputs = [ dropbox annexremote humanfriendly ];

  meta = with lib; {
    description = "Git-annex special remote for Dropbox";
    homepage = "https://pypi.org/project/git-annex-remote-dbx/";
    license = licenses.mit;
    mainProgram = "git-annex-remote-dbx";
  };
}

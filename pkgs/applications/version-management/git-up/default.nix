{ lib
, pythonPackages
, git
}:

pythonPackages.buildPythonApplication rec {
  pname = "git-up";
  version = "1.6.1";

  src = pythonPackages.fetchPypi {
    inherit pname version;
    sha256 = "0gs791yb0cndg9879vayvcj329jwhzpk6wrf9ri12l5hg8g490za";
  };

  # git should be on path for tool to work correctly
  propagatedBuildInputs = [
    git
  ] ++ (with pythonPackages; [
    click
    colorama
    docopt
    gitpython
    six
    termcolor
  ]);

  nativeCheckInputs = [ git pythonPackages.nose ]; # git needs to be on path
  # 1. git fails to run as it cannot detect the email address, so we set it
  # 2. $HOME is by default not a valid dir, so we have to set that too
  # https://github.com/NixOS/nixpkgs/issues/12591
  preCheck = ''
      export HOME=$TMPDIR
      git config --global user.email "nobody@example.com"
      git config --global user.name "Nobody"
    '';

  postInstall = ''
    rm -r $out/${pythonPackages.python.sitePackages}/PyGitUp/tests
  '';

  meta = with lib; {
    homepage = "https://github.com/msiemens/PyGitUp";
    description = "A git pull replacement that rebases all local branches when pulling";
    license = licenses.mit;
    maintainers = with maintainers; [ peterhoeg ];
    platforms = platforms.all;
  };
}

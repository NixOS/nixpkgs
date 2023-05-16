{ lib
, pythonPackages
<<<<<<< HEAD
, fetchPypi
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, git
}:

pythonPackages.buildPythonApplication rec {
  pname = "git-up";
<<<<<<< HEAD
  version = "2.2.0";
  format = "pyproject";

  src = fetchPypi {
    pname = "git_up";
    inherit version;
    hash = "sha256-GTX2IWLQ48yWfPnmtEa9HJ5umQLttqgTlgZQlaWgeE4=";
  };

  nativeBuildInputs = with pythonPackages; [
    poetry-core
  ];

=======
  version = "1.6.1";

  src = pythonPackages.fetchPypi {
    inherit pname version;
    sha256 = "0gs791yb0cndg9879vayvcj329jwhzpk6wrf9ri12l5hg8g490za";
  };

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  # git should be on path for tool to work correctly
  propagatedBuildInputs = [
    git
  ] ++ (with pythonPackages; [
<<<<<<< HEAD
    colorama
    gitpython
    termcolor
  ]);

  nativeCheckInputs = [
    git
    pythonPackages.pytestCheckHook
  ];

=======
    click
    colorama
    docopt
    gitpython
    six
    termcolor
  ]);

  nativeCheckInputs = [ git pythonPackages.nose ]; # git needs to be on path
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  # 1. git fails to run as it cannot detect the email address, so we set it
  # 2. $HOME is by default not a valid dir, so we have to set that too
  # https://github.com/NixOS/nixpkgs/issues/12591
  preCheck = ''
<<<<<<< HEAD
    export HOME=$TMPDIR
    git config --global user.email "nobody@example.com"
    git config --global user.name "Nobody"
  '';
=======
      export HOME=$TMPDIR
      git config --global user.email "nobody@example.com"
      git config --global user.name "Nobody"
    '';
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

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

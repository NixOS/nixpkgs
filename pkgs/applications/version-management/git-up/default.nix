{ lib
, pythonPackages
, fetchPypi
, git
}:

pythonPackages.buildPythonApplication rec {
  pname = "git-up";
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

  # git should be on path for tool to work correctly
  propagatedBuildInputs = [
    git
  ] ++ (with pythonPackages; [
    colorama
    gitpython
    termcolor
  ]);

  nativeCheckInputs = [
    git
    pythonPackages.pytestCheckHook
  ];

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
    mainProgram = "git-up";
  };
}

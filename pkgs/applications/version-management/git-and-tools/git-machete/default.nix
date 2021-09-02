{ lib, buildPythonApplication, fetchPypi
, installShellFiles, pbr
, flake8, mock, pycodestyle, pylint, stestr, tox
, nix-update-script
, testVersion, git-machete
}:

buildPythonApplication rec {
  pname = "git-machete";
  version = "3.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0mq6hmb3wvj0ash27h4zyl46l3fikpf0mv3ng330lcy6v7bhy5b8";
  };

  nativeBuildInputs = [ installShellFiles pbr ];

  checkInputs = [ flake8 mock pycodestyle pylint stestr tox ];

  postInstall = ''
      installShellCompletion --bash --name git-machete completion/git-machete.completion.bash
      installShellCompletion --zsh --name _git-machete completion/git-machete.completion.zsh
  '';

  passthru = {
    updateScript = nix-update-script {
      attrPath = pname;
    };

    tests = {
      version = testVersion {
        package = git-machete;
      };
    };
  };

  meta = with lib; {
    homepage = "https://github.com/VirtusLab/git-machete";
    description = "Git repository organizer and rebase/merge workflow automation tool";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ blitz ];
  };
}

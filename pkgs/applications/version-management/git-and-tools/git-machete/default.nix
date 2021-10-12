{ lib
, buildPythonApplication
, fetchFromGitHub
, installShellFiles
, git
, stestr
, nix-update-script
, testVersion
, git-machete
}:

buildPythonApplication rec {
  pname = "git-machete";
  version = "3.3.0";

  src = fetchFromGitHub {
    owner = "virtuslab";
    repo = pname;
    rev = "v${version}";
    sha256 = "0sx45y1d1v6y66msjc1lw9jhjppgbxqj145kivmd7lr6ccw68kav";
  };

  nativeBuildInputs = [ installShellFiles ];

  checkInputs = [ git stestr ];

  postCheck = ''
    stestr run
  '';

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
    maintainers = with maintainers; [ blitz ];
  };
}

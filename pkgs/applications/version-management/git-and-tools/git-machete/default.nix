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
  version = "3.5.0";

  src = fetchFromGitHub {
    owner = "virtuslab";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-kR37TClFMkoe4e46g/omfwZCrQFr7gukW7I70WI9+dw=";
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

  postInstallCheck = ''
    git init
    test "$($out/bin/git-machete version)" = "git-machete version ${version}"
  '';

  passthru = {
    updateScript = nix-update-script {
      attrPath = pname;
    };
  };

  meta = with lib; {
    homepage = "https://github.com/VirtusLab/git-machete";
    description = "Git repository organizer and rebase/merge workflow automation tool";
    license = licenses.mit;
    maintainers = with maintainers; [ blitz ];
  };
}

{ lib, buildPythonApplication, fetchPypi
, installShellFiles, pbr
, flake8, mock, pycodestyle, pylint, tox }:

buildPythonApplication rec {
  pname = "git-machete";
  version = "3.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "077xs3grjidahxz1gc93565b25blf97lwsljmkmr0yapps8z630d";
  };

  nativeBuildInputs = [ installShellFiles pbr ];

  # TODO: Add missing check inputs (2019-11-22):
  # - stestr
  doCheck = false;
  checkInputs = [ flake8 mock pycodestyle pylint tox ];

  postInstall = ''
      installShellCompletion --bash --name git-machete completion/git-machete.completion.bash
      installShellCompletion --zsh --name _git-machete completion/git-machete.completion.zsh
  '';

  meta = with lib; {
    homepage = "https://github.com/VirtusLab/git-machete";
    description = "Git repository organizer and rebase/merge workflow automation tool";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = [ maintainers.blitz ];
  };
}

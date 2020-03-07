{ lib, buildPythonApplication, fetchPypi
, installShellFiles, pbr
, flake8, mock, pycodestyle, pylint, tox }:

buildPythonApplication rec {
  pname = "git-machete";
  version = "2.13.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1ll5l1f3vcib9a8qsqm8bfzz4g4q1dnr389x7x26kl13n6a50wib";
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
    homepage = https://github.com/VirtusLab/git-machete;
    description = "Git repository organizer and rebase workflow automation tool";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = [ maintainers.blitz ];
  };
}

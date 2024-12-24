{
  lib,
  buildPythonApplication,
  fetchFromGitHub,
  git,
  pytestCheckHook,
  pytest-cov-stub,
  pytest-mock,
}:

buildPythonApplication rec {
  pname = "git-archive-all";
  version = "1.23.1";

  src = fetchFromGitHub {
    owner = "Kentzo";
    repo = "git-archive-all";
    rev = version;
    hash = "sha256-fIPjggOx+CEorj1bazz8s81ZdppkTL0OlA5tRqCYZyc=";
  };

  # * Don't use pinned dependencies
  # * Remove formatter and coverage generator
  # * Don't fail on warnings. Almost all tests output this warning:
  #   ResourceWarning: unclosed file [...]/repo.tar
  #   https://github.com/Kentzo/git-archive-all/issues/90
  postPatch = ''
    substituteInPlace setup.cfg \
      --replace pycodestyle==2.5.0 "" \
      --replace pytest==5.2.2 pytest \
      --replace pytest-cov==2.8.1 "" \
      --replace pytest-mock==1.11.2 pytest-mock \
      --replace "filterwarnings = error" ""
    substituteInPlace test_git_archive_all.py \
      --replace "import pycodestyle" ""
  '';

  nativeCheckInputs = [
    git
  ];

  checkInputs = [
    pytestCheckHook
    pytest-cov-stub
    pytest-mock
  ];

  disabledTests = [ "pycodestyle" ];

  preCheck = ''
    export HOME="$(mktemp -d)"
  '';

  meta = with lib; {
    description = "Archive a repository with all its submodules";
    longDescription = ''
      A python script wrapper for git-archive that archives a git superproject
      and its submodules, if it has any. Takes into account .gitattributes
    '';
    homepage = "https://github.com/Kentzo/git-archive-all";
    license = licenses.mit;
    maintainers = with maintainers; [ fgaz ];
    mainProgram = "git-archive-all";
  };
}

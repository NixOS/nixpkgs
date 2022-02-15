{ lib
, buildPythonApplication
, fetchFromGitHub
, installShellFiles
, git
, pytest
, nix-update-script
, testVersion
, git-machete
}:

buildPythonApplication rec {
  pname = "git-machete";
  version = "3.7.2";

  src = fetchFromGitHub {
    owner = "virtuslab";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-7WaLUCJr29i7JW5YAJG1AuYnSLKRMpAEnCY2i4Zle+c=";
  };

  nativeBuildInputs = [ installShellFiles ];

  checkInputs = [ git pytest ];

  ### Maybe not needed at all? since `python setup.py test` is executed anyway?
  /*
  Executing setuptoolsCheckPhase
  running test
  WARNING: Testing via this command is deprecated and will be removed in a future version. Users looking for a generic test entry point independent of test runner are encouraged to use tox.
  running egg_info
  writing git_machete.egg-info/PKG-INFO
  writing dependency_links to git_machete.egg-info/dependency_links.txt
  writing top-level names to git_machete.egg-info/top_level.txt
  reading manifest file 'git_machete.egg-info/SOURCES.txt'
  reading manifest template 'MANIFEST.in'
  adding license file 'LICENSE'
  writing manifest file 'git_machete.egg-info/SOURCES.txt'
  running build_ext
  test_add (git_machete.tests.functional.test_machete.MacheteTester)
  Verify behaviour of a 'git machete add' command. ... ok
  ....
  */
  postCheck = ''
    pytest
  '';

  postInstall = ''
    installShellCompletion --bash --name git-machete completion/git-machete.completion.bash
    installShellCompletion --zsh --name _git-machete completion/git-machete.completion.zsh
    installShellCompletion --fish completion/git-machete.fish
  '';

  postInstallCheck = ''
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

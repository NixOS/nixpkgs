{
  lib,
  buildPythonApplication,
  fetchFromGitHub,
  setuptools,
  dropbox,
  annexremote,
  humanfriendly,
}:

buildPythonApplication (finalAttrs: {
  pname = "git-annex-remote-dbx";
  version = "1.0.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "montag451";
    repo = "git-annex-remote-dbx";
    tag = "v${finalAttrs.version}";
    hash = "sha256-a1mCLFd9fykzX3BxQBsOe6oPUzQjAzyfxExFlXCOAvQ=";
  };

  build-system = [ setuptools ];

  dependencies = [
    dropbox
    annexremote
    humanfriendly
  ];

  meta = {
    description = "Git-annex special remote for Dropbox";
    homepage = "https://pypi.org/project/git-annex-remote-dbx/";
    license = lib.licenses.mit;
    mainProgram = "git-annex-remote-dbx";
    maintainers = with lib.maintainers; [ matthiasbeyer ];
  };
})

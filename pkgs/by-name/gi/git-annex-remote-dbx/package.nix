{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "git-annex-remote-dbx";
  version = "1.0.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "montag451";
    repo = "git-annex-remote-dbx";
    tag = "v${finalAttrs.version}";
    hash = "sha256-a1mCLFd9fykzX3BxQBsOe6oPUzQjAzyfxExFlXCOAvQ=";
  };

  build-system = [ python3Packages.setuptools ];

  dependencies = with python3Packages; [
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

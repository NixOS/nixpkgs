{
  lib,
  vimUtils,
  fetchFromGitLab,
  nix-update-script,
}:
let
  version = "0.1.1";
in
vimUtils.buildVimPlugin {
  pname = "gitlab.vim";
  inherit version;

  src = fetchFromGitLab {
    owner = "gitlab-org/editor-extensions";
    repo = "gitlab.vim";
    rev = "v${version}";
    hash = "sha256-W/FV+i/QJYX6A8uyxAQN4ov1kMd9UFCghFmSQp1kbnM=";
  };

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Integrate GitLab Duo with Neovim";
    homepage = "https://gitlab.com/gitlab-org/editor-extensions/gitlab.vim";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
  };
}

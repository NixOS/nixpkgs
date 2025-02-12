{
  lib,
  vimUtils,
  fetchFromGitLab,
  nix-update-script,
}:
vimUtils.buildVimPlugin {
  pname = "gitlab.vim";
  version = "0.1.1";

  src = fetchFromGitLab {
    owner = "gitlab-org/editor-extensions";
    repo = "gitlab.vim";
    rev = "62a60341df24ccecb73bc9ae34a198674bb12faf";
    hash = "sha256-9G5H3MUdE++hR7p8nsoxK5kuA84k8oJBMvOa01PZrsA=";
  };

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Integrate GitLab Duo with Neovim";
    homepage = "https://gitlab.com/gitlab-org/editor-extensions/gitlab.vim";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
  };
}

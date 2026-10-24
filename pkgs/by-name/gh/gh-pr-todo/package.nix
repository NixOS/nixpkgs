{
  buildGoModule,
  fetchFromGitHub,
  lib,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "gh-pr-todo";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "Suree33";
    repo = "gh-pr-todo";
    tag = "v${finalAttrs.version}";
    hash = "sha256-F1gPI2Qoebm3GdtsV4JyZqBQyJtjgNWV1IjA5RzK04s=";
  };

  vendorHash = "sha256-a+WKEWXC917SAOuOM6bGZuGHkvbwehNbo1tjhsjoAhE=";

  __structuredAttrs = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "GitHub CLI extension to extract TODO comments from pull request diffs";
    homepage = "https://github.com/Suree33/gh-pr-todo";
    changelog = "https://github.com/Suree33/gh-pr-todo/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ suree33 ];
    mainProgram = "gh-pr-todo";
  };
})

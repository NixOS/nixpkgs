{
  fetchFromGitHub,
  lib,
  buildNpmPackage,
}:
buildNpmPackage (finalAttrs: {
  pname = "git-jump";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "mykolaharmash";
    repo = "git-jump";
    tag = "v${finalAttrs.version}";
    hash = "sha256-0jX7IiYWLgzjZDEc4lXylqkHqawgnOKI4I9ShzlC+8U=";
  };

  npmDepsHash = "sha256-9f3Ws2V6li+u6qVMD3J6IHSNvG5TGvj0XfAZArgIi1w=";

  postInstall = ''
    installManPage git-jump.1
  '';

  preFixup = ''
    rm $out/lib/node_modules/git-jump/node_modules/.bin/{tsc,tsserver}
  '';

  meta = {
    description = "Improved navigation between Git branches";
    homepage = "https://github.com/mykolaharmash/git-jump";
    license = lib.licenses.mit;
    mainProgram = "git-jump";
    maintainers = with lib.maintainers; [ juliusfreudenberger ];
  };
})

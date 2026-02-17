{
  lib,
  buildGoModule,
  fetchFromGitHub,
  gitMinimal,
}:
buildGoModule (finalAttrs: {
  pname = "git-bug-migration";
  version = "0.3.4";

  src = fetchFromGitHub {
    owner = "MichaelMure";
    repo = "git-bug-migration";
    rev = "v${finalAttrs.version}";
    hash = "sha256-IOBgrU3C0ZHD2wx9LRVgKEJzDlUj6z2UXlHGU3tdTdQ=";
  };

  vendorHash = "sha256-Hid9OK91LNjLmDHam0ZlrVQopVOsqbZ+BH2rfQi5lS0=";

  nativeCheckInputs = [ gitMinimal ];

  ldflags = [
    "-X main.GitExactTag=${finalAttrs.version}"
    "-X main.GitLastTag=${finalAttrs.version}"
  ];

  preCheck = ''
    export HOME=$(mktemp -d)
    git config --global user.name 'Nixpkgs Test User'
    git config --global user.email 'nobody@localhost'
  '';

  meta = {
    description = "Tool for upgrading repositories using git-bug to new versions";
    homepage = "https://github.com/MichaelMure/git-bug-migration";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      DeeUnderscore
      sudoforge
    ];
    mainProgram = "git-bug-migration";
  };
})

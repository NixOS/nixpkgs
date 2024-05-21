{
  lib,
  fetchFromGitea,
  buildGoModule,
}:
buildGoModule rec {
  pname = "nodeinfo";
  version = "0.3.2";
  vendorHash = "sha256-4nHdz/Js8xBUMiH+hH+hSYP25cB4yHbe+QVk0RMqLgc=";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "thefederationinfo";
    repo = "nodeinfo-go";
    rev = "refs/tags/v${version}";
    hash = "sha256-NNrMv4AS7ybuJfTgs+p61btSIxo+iMvzH7Y5ct46Dag=";
  };

  tags = "extension";

  sourceRoot = "${src.name}/cli";

  CGO_ENABLED = 0;

  meta = with lib; {
    mainProgram = "nodeinfo";
    description = "A command line tool to query nodeinfo based on a given domain";
    homepage = "https://codeberg.org/thefederationinfo/nodeinfo-go";
    changelog = "https://codeberg.org/thefederationinfo/nodeinfo-go/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ _6543 ];
  };
}

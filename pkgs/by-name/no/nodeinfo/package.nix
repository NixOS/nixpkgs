{
  lib,
  fetchFromGitea,
  buildGoModule,
}:
buildGoModule rec {
  pname = "nodeinfo";
  version = "1.0.0";
  vendorHash = "sha256-P0klk3YWa2qprCUNUjiuF+Akxh246WCu4vwUAZmSDCw=";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "thefederationinfo";
    repo = "nodeinfo-go";
    rev = "refs/tags/v${version}";
    hash = "sha256-XwK3QeVDQMZD5G79XPJTAJyilVgYFVgZORHYTBI0gIQ=";
  };

  modRoot = "./cli";
  tags = [ "extension" ];
  ldflags = [
    "-s"
    "-w"
  ];

  env.CGO_ENABLED = 0;

  meta = {
    mainProgram = "nodeinfo";
    description = "Command line tool to query nodeinfo based on a given domain";
    homepage = "https://codeberg.org/thefederationinfo/nodeinfo-go";
    changelog = "https://codeberg.org/thefederationinfo/nodeinfo-go/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers._6543 ];
  };
}

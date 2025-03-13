{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule rec {
  pname = "benthos";
  version = "4.45.1";

  src = fetchFromGitHub {
    owner = "redpanda-data";
    repo = "benthos";
    tag = "v${version}";
    hash = "sha256-pbbeVNpGCjLxhesq88aoeTnaawMgDTCx0wDA6Y2sXsM=";
  };

  proxyVendor = true;

  subPackages = [
    "cmd/benthos"
  ];

  vendorHash = "sha256-1XEIZemPo8IuSpakTr7Zy4Jqd/vukL5ORuW/5tA6otw=";

#  doCheck = false;

  ldflags = [
    "-s"
    "-w"
    "-X github.com/redpanda-data/benthos/v4/internal/cli.Version=${version}"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Fancy stream processing made operationally mundane";
    mainProgram = "benthos";
    homepage = "https://www.benthos.dev";
    changelog = "https://github.com/benthosdev/benthos/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sagikazarmark ];
  };
}

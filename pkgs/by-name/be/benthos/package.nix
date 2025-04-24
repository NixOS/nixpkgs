{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule rec {
  pname = "benthos";
  version = "4.42.0";

  src = fetchFromGitHub {
    owner = "redpanda-data";
    repo = "benthos";
    rev = "refs/tags/v${version}";
    hash = "sha256-JLBH3eFhqPaLK5kCqsnUF54Izu+fEFQbP+cehvrHL9Q=";
  };

  proxyVendor = true;

  subPackages = [
    "cmd/benthos"
  ];

  vendorHash = "sha256-a8FXB3sripwCqCZDQKl1f0rg11LXvwuDrOnsX+Q8UD0=";

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

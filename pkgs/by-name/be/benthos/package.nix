{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule rec {
  pname = "benthos";
  version = "4.40.0";

  src = fetchFromGitHub {
    owner = "redpanda-data";
    repo = "benthos";
    rev = "refs/tags/v${version}";
    hash = "sha256-FABy2Fl32qS0zVQ+pDYUXQjTvAxn3eDCqvQn8kpZCjw=";
  };

  proxyVendor = true;

  subPackages = [
    "cmd/benthos"
  ];

  vendorHash = "sha256-LCw15Q/kr5XCoBAOyGVOCcD/FcqUodlYLETNsRbOeG8=";

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

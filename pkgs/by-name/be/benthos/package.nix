{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule rec {
  pname = "benthos";
  version = "4.54.0";

  src = fetchFromGitHub {
    owner = "redpanda-data";
    repo = "benthos";
    tag = "v${version}";
    hash = "sha256-+49Gb+5mPCbeNcnFHckNCyWRvdpOP+xy34bn0I97tWc=";
  };

  proxyVendor = true;

  subPackages = [
    "cmd/benthos"
  ];

  vendorHash = "sha256-g1jqVJfpH2EsTYoXMGp0HiUEqKlprgMYqmzecGWKmoo=";

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

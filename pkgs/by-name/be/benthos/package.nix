{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "benthos";
  version = "4.76.0";

  src = fetchFromGitHub {
    owner = "redpanda-data";
    repo = "benthos";
    tag = "v${finalAttrs.version}";
    hash = "sha256-BSXK5ylRcYgp88kpkMLD3aWzWGGG0deqJ5suaoxDedw=";
  };

  proxyVendor = true;

  subPackages = [
    "cmd/benthos"
  ];

  vendorHash = "sha256-PhFEbIO/XwkYruRd4o+DQG4XvdcWMQr9Bn08Pb2R7VI=";

  #  doCheck = false;

  ldflags = [
    "-s"
    "-w"
    "-X github.com/redpanda-data/benthos/v4/internal/cli.Version=${finalAttrs.version}"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Fancy stream processing made operationally mundane";
    mainProgram = "benthos";
    homepage = "https://www.benthos.dev";
    changelog = "https://github.com/benthosdev/benthos/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sagikazarmark ];
  };
})

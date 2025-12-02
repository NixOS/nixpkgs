{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "smtprelay";
  version = "1.13.0";

  src = fetchFromGitHub {
    owner = "decke";
    repo = "smtprelay";
    tag = "v${version}";
    hash = "sha256-8xDyJFSBCHRYVfJ5xDjSHVV3f4nSyW/2DUqQlARS1ns=";
  };

  vendorHash = "sha256-LZZubLD+uQz6o0SW0bqbcU/VO7jOhsWB9MrQ0KrebI0=";

  subPackages = [
    "."
  ];

  env.CGO_ENABLED = 0;

  # We do not supply the build time as the build wouldn't be reproducible otherwise.
  ldflags = [
    "-s"
    "-w"
    "-X=main.appVersion=v${version}"
  ];

  meta = {
    homepage = "https://github.com/decke/smtprelay";
    description = "Simple Golang SMTP relay/proxy server";
    mainProgram = "smtprelay";
    changelog = "https://github.com/decke/smtprelay/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ juliusrickert ];
  };
}

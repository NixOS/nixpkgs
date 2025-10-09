{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "smtprelay";
  version = "1.12.0";

  src = fetchFromGitHub {
    owner = "decke";
    repo = "smtprelay";
    tag = "v${version}";
    hash = "sha256-mlaTZXzbZLdtzDqj8y2e8WjyaNxOPQ1a6YXbPhCxc1c=";
  };

  vendorHash = "sha256-wr53cIkygsM0+R02PjQAtIPrQDu7vploRTsMOrPBt4o=";

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

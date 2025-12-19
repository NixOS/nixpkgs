{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "go-dnscollector";
  version = "1.14.0";

  src = fetchFromGitHub {
    owner = "dmachard";
    repo = "go-dnscollector";
    tag = "v${version}";
    hash = "sha256-J6h/td5vCZwVruamZziIxRhAOdLdlv3Aupz9m0bExU4=";
  };

  vendorHash = "sha256-BQLlEY9CJDwJRbzB5kflBwwxcWMLbaqgWUtz2p3CJsE=";

  subPackages = [ "." ];

  meta = {
    description = "Ingesting, pipelining, and enhancing your DNS logs with usage indicators, security analysis, and additional metadata";
    homepage = "https://github.com/dmachard/go-dnscollector";
    changelog = "https://github.com/dmachard/DNS-collector/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ shift ];
  };
}

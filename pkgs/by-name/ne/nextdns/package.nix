{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule (finalAttrs: {
  pname = "nextdns";
  version = "1.49.0";

  src = fetchFromGitHub {
    owner = "nextdns";
    repo = "nextdns";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-kBmLVBwzt+oqM3Hx8qeyMuOw9bNU+r2FDueUTWWae8Q=";
  };

  vendorHash = "sha256-sDofbS1kq3nQDufxiYse4uxcPE1oTSITsI6RU7pFFSM=";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${finalAttrs.version}"
  ];

  meta = {
    description = "NextDNS DNS/53 to DoH Proxy";
    homepage = "https://nextdns.io";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pnelson ];
    mainProgram = "nextdns";
  };
})

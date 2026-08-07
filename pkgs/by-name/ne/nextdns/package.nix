{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule (finalAttrs: {
  pname = "nextdns";
  version = "1.47.3";

  src = fetchFromGitHub {
    owner = "nextdns";
    repo = "nextdns";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-oTxa/iZ13WSrHOxlmKL55veXhGq1m1Md9RZESdwsKJ0=";
  };

  vendorHash = "sha256-Q6gh9E6FzvQn+Lyv3Tr3uLAO/r8zlF8im6xAG2YnuoU=";

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

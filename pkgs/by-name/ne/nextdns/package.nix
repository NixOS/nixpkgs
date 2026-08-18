{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule (finalAttrs: {
  pname = "nextdns";
  version = "1.48.0";

  src = fetchFromGitHub {
    owner = "nextdns";
    repo = "nextdns";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-iTo96BabjPJLe2E4iThDLJJ4VZ/XjUgKB6vqWA/VyWw=";
  };

  vendorHash = "sha256-K4KbV4Tg30bCMksVMV3xx2sseAB2ery6u+K1V2c0mxQ=";

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

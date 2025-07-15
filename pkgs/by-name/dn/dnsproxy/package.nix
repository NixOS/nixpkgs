{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "dnsproxy";
  version = "0.75.6";

  src = fetchFromGitHub {
    owner = "AdguardTeam";
    repo = "dnsproxy";
    tag = "v${finalAttrs.version}";
    hash = "sha256-zMSwAbNwomb2XXOtnXJvO+ehUPYz0F8lzRkhhHhk3QQ=";
  };

  vendorHash = "sha256-k+F85fPzIvSr/M/oRkO7kmXUStN+zWpvo9JJIKlgSFQ=";

  ldflags = [
    "-s"
    "-w"
    "-X"
    "github.com/AdguardTeam/dnsproxy/internal/version.version=${finalAttrs.version}"
  ];

  # Development tool dependencies; not part of the main project
  excludedPackages = [ "internal/tools" ];

  doCheck = false;

  meta = {
    description = "Simple DNS proxy with DoH, DoT, and DNSCrypt support";
    homepage = "https://github.com/AdguardTeam/dnsproxy";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      contrun
      diogotcorreia
    ];
    mainProgram = "dnsproxy";
  };
})

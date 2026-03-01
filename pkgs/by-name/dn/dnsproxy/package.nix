{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "dnsproxy";
  version = "0.79.0";

  src = fetchFromGitHub {
    owner = "AdguardTeam";
    repo = "dnsproxy";
    tag = "v${finalAttrs.version}";
    hash = "sha256-R/TBsge+Jd11EvDEx3B9FD/bHdi2BQZTpXLNlvEyERk=";
  };

  vendorHash = "sha256-NS7MsK7QXg8tcAytYd9FGvaYZcReYkO5ESPpLbzL0IQ=";

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

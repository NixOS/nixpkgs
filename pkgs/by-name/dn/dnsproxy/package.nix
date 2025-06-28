{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "dnsproxy";
  version = "0.76.0";

  src = fetchFromGitHub {
    owner = "AdguardTeam";
    repo = "dnsproxy";
    tag = "v${finalAttrs.version}";
    hash = "sha256-R5/Y1nUyjqB4Q9v3KSn9Bav+5ub9jIFMdRor2xl4bIo=";
  };

  vendorHash = "sha256-BIp02IL2/JgW4qRH5inZKstt+9CWHsX9ZAyOLoQa1go=";

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

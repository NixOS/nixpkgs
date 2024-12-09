{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "dnsproxy";
  version = "0.73.4";

  src = fetchFromGitHub {
    owner = "AdguardTeam";
    repo = "dnsproxy";
    rev = "v${version}";
    hash = "sha256-LCo/SWfsmwbHhDZRf9PRN0FbB81js616YLUQG/Xtz2A=";
  };

  vendorHash = "sha256-5NTHIeKwruVMO7mBxcO+wglUslOJVFmxS2krDfdFAgg=";

  ldflags = [
    "-s"
    "-w"
    "-X"
    "github.com/AdguardTeam/dnsproxy/internal/version.version=${version}"
  ];

  # Development tool dependencies; not part of the main project
  excludedPackages = [ "internal/tools" ];

  doCheck = false;

  meta = with lib; {
    description = "Simple DNS proxy with DoH, DoT, and DNSCrypt support";
    homepage = "https://github.com/AdguardTeam/dnsproxy";
    license = licenses.asl20;
    maintainers = with maintainers; [
      contrun
      diogotcorreia
    ];
    mainProgram = "dnsproxy";
  };
}

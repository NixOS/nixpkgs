{
  lib,
  fetchurl,
  buildGoModule,
  libpcap,
}:

buildGoModule (final: {

  pname = "ptcpdump";
  version = "0.35.0";

  src = fetchurl {
    url = "https://github.com/mozillazg/ptcpdump/archive/refs/tags/v${final.version}.tar.gz";
    hash = "sha256-8bZCsPClcxkd1gE2Epkm1jH7okmERBLc/x7u5DclbPI=";
  };

  vendorHash = null;

  buildInputs = [ libpcap ];

  tags = [ "dynamic" ];

  ldflags = [
    "-X github.com/mozillazg/ptcpdump/internal.Version=v${final.version}"
  ];

  checkFlags =
    let
      # Skip tests that require network access
      skippedTests = [
        "Test_loadSpecFromBTFHub"
        "Test_loadSpecFromOpenanolis"
      ];
    in
    [ "-skip=^${builtins.concatStringsSep "$|^" skippedTests}$" ];

  meta = with lib; {
    homepage = "https://github.com/mozillazg/ptcpdump/";
    description = "Process-aware, eBPF-based tcpdump";
    license = licenses.mit;
    maintainers = with maintainers; [ neilmayhew ];
  };
})

{
  lib,
  fetchFromGitHub,
  buildGoModule,
  libpcap,
}:

buildGoModule (finalAttr: {
  pname = "ptcpdump";
  version = "0.35.0";

  src = fetchFromGitHub {
    owner = "mozillazg";
    repo = "ptcpdump";
    tag = "v${finalAttr.version}";
    hash = "sha256-aPP167Uc/VQZ6hdbYLpyLmgua7OpYmqHBWtev6MHU6Y=";
  };

  vendorHash = null;

  buildInputs = [ libpcap ];

  tags = [ "dynamic" ];

  ldflags = [
    "-X github.com/mozillazg/ptcpdump/internal.Version=v${finalAttr.version}"
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

  meta = {
    homepage = "https://github.com/mozillazg/ptcpdump/";
    description = "Process-aware, eBPF-based tcpdump";
    mainProgram = "ptcpdump";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ neilmayhew ];
  };
})

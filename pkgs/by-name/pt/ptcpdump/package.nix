{
  lib,
  fetchFromGitHub,
  versionCheckHook,
  buildGoModule,
  libpcap,
}:

buildGoModule (finalAttrs: {
  pname = "ptcpdump";
  version = "0.37.1";

  src = fetchFromGitHub {
    owner = "mozillazg";
    repo = "ptcpdump";
    tag = "v${finalAttrs.version}";
    hash = "sha256-oLO7dYMWKv7uDt4UbtQtdsK1fny0O7Zfnb5QsmTMAA4=";
  };

  vendorHash = null;

  buildInputs = [ libpcap ];

  tags = [ "dynamic" ];

  ldflags = [
    "-X github.com/mozillazg/ptcpdump/internal.Version=v${finalAttrs.version}"
  ];
  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

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
    platforms = lib.platforms.linux;
  };
})

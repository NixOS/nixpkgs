{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
  stdenv,
}:

buildGoModule rec {
  pname = "dnsmasq_exporter";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "google";
    repo = "dnsmasq_exporter";
    rev = "v${version}";
    hash = "sha256-2sOOJWEEseWwozIyZ7oes400rBjlxIrOOtkP3rSNFXo=";
  };

  vendorHash = "sha256-oD68TCNJKwjY3iwE/pUosMIMGOhsWj9cHC/+hq3xxI4=";

  doCheck = false;

  passthru.tests = { inherit (nixosTests.prometheus-exporters) dnsmasq; };

  meta = {
    inherit (src.meta) homepage;
    description = "Dnsmasq exporter for Prometheus";
    mainProgram = "dnsmasq_exporter";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      globin
    ];
    # Broken on darwin for Go toolchain > 1.22, with error:
    # 'link: golang.org/x/net/internal/socket: invalid reference to syscall.recvmsg'
    broken = stdenv.hostPlatform.isDarwin;
  };
}

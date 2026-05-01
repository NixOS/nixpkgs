{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule (finalAttrs: {
  pname = "free5gc-n3iwf";
  version = "1.3.3";

  src = fetchFromGitHub {
    owner = "free5gc";
    repo = "n3iwf";
    tag = "v${finalAttrs.version}";
    hash = "sha256-BFr+d8YQNXcHcOgYZxuh+IFJ9/nMxEEDtTgbzhiFKCY=";
  };

  vendorHash = "sha256-tvMyRV/a40ubPoT1uGxZ1g2q4qJ3K9fof7Xt5IN8vC4=";

  ldflags = [
    "-X github.com/free5gc/util/version.VERSION=v${finalAttrs.version}"
  ];

  __structuredAttrs = true;

  checkFlags = [
    "-skip TestCheckIKEMessage"
    # --- FAIL: TestCheckIKEMessage (0.00s)
    #     Error Trace:    /build/source/internal/ike/server_test.go:170
    #     Error:          Received unexpected error: dial udp 10.100.100.2:500: connect: network is unreachable
  ];

  meta = {
    description = "Open source 5G core network based on 3GPP R15";
    homepage = "https://free5gc.org/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ felbinger ];
    platforms = lib.platforms.linux;
  };
})

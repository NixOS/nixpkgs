{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule (finalAttrs: {
  pname = "free5gc-udr";
  version = "1.4.3";

  src = fetchFromGitHub {
    owner = "free5gc";
    repo = "udr";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ZfZ9amkKSL+C6ArUmZ+ckj7w++qI1/nlJmPHtsxFaf4=";
  };

  vendorHash = "sha256-LCUT9bkUr7telvQMvg/ZgsLu6352DOP3iy9cBhDjsj8=";

  ldflags = [
    "-X github.com/free5gc/util/version.VERSION=v${finalAttrs.version}"
  ];

  __structuredAttrs = true;

  checkFlags = [
    "-skip TestUDR_InfluData_CreateThenGet"
    # --- FAIL: TestUDR_InfluData_CreateThenGet (30.00s)
    #     Error Trace:    /build/source/internal/sbi/api_sanity_test.go:64
    #     Error:          Expected nil, but got: topology.ServerSelectionError
  ];

  meta = {
    description = "Open source 5G core network based on 3GPP R15";
    homepage = "https://free5gc.org/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ felbinger ];
    platforms = lib.platforms.linux;
  };
})

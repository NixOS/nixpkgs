{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:
buildGoModule (finalAttrs: {
  pname = "free5gc-udr";
  version = "1.4.5";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "free5gc";
    repo = "udr";
    tag = "v${finalAttrs.version}";
    hash = "sha256-h0q20ut11aAF3nNN7Yq7MmYiea0DfZ5y9q/Ygb0bozY=";
  };

  vendorHash = "sha256-vDTHS10Ie7qk3RVEfgjd00WukDI6Upn+IGmYmI4MQiE=";

  ldflags = [
    "-X github.com/free5gc/util/version.VERSION=v${finalAttrs.version}"
  ];

  postInstall = ''
    mv -v $out/bin/cmd $out/bin/free5gc-udr
  '';

  doInstallCheck = true;

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "irrelevant"; # has no version flag, empty string didn't work

  checkFlags = [
    "-skip TestUDR_InfluData_CreateThenGet"
    # --- FAIL: TestUDR_InfluData_CreateThenGet (30.00s)
    #     Error Trace:    /build/source/internal/sbi/api_sanity_test.go:64
    #     Error:          Expected nil, but got: topology.ServerSelectionError
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Open source 5G core network based on 3GPP R15";
    homepage = "https://free5gc.org/";
    changelog = "https://github.com/free5gc/udr/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ felbinger ];
    platforms = lib.platforms.linux;
    mainProgram = "free5gc-udr";
  };
})

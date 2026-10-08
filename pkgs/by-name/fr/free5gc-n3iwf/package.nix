{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:
buildGoModule (finalAttrs: {
  pname = "free5gc-n3iwf";
  version = "1.3.5";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "free5gc";
    repo = "n3iwf";
    tag = "v${finalAttrs.version}";
    hash = "sha256-9J7Ig/UBIz27elgcPgrIkaJcEyKpR+T3DosU30BMc80=";
  };

  vendorHash = "sha256-Jov/K0gvi8R7vZ4sHkJ5eINM74L7nn421544WhwBxUc=";

  ldflags = [
    "-X github.com/free5gc/util/version.VERSION=v${finalAttrs.version}"
  ];

  postInstall = ''
    mv -v $out/bin/cmd $out/bin/free5gc-n3iwf
  '';

  doInstallCheck = true;

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "irrelevant"; # has no version flag, empty string didn't work

  checkFlags = [
    "-skip TestCheckIKEMessage"
    # --- FAIL: TestCheckIKEMessage (0.00s)
    #     Error Trace:    /build/source/internal/ike/server_test.go:170
    #     Error:          Received unexpected error: dial udp 10.100.100.2:500: connect: network is unreachable
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Open source 5G core network based on 3GPP R15";
    homepage = "https://free5gc.org/";
    changelog = "https://github.com/free5gc/n3iwf/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ felbinger ];
    platforms = lib.platforms.linux;
    mainProgram = "free5gc-n3iwf";
  };
})

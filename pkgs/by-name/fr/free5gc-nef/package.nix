{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:
buildGoModule (finalAttrs: {
  pname = "free5gc-nef";
  version = "1.2.3";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "free5gc";
    repo = "nef";
    tag = "v${finalAttrs.version}";
    hash = "sha256-FaLL+RMAub8weCzE68UL6ZpjMf2GRfoekt1X2QjtVEw=";
  };

  vendorHash = "sha256-GS86eLcF0hlnnMPFsKGfhsUDcnjMQVq30oe0KxEbAzQ=";

  ldflags = [
    "-X github.com/free5gc/util/version.VERSION=v${finalAttrs.version}"
  ];

  postInstall = ''
    mv -v $out/bin/cmd $out/bin/free5gc-nef
  '';

  doInstallCheck = true;

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "irrelevant"; # has no version flag, empty string didn't work

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Open source 5G core network based on 3GPP R15";
    homepage = "https://free5gc.org/";
    changelog = "https://github.com/free5gc/nef/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ felbinger ];
    platforms = lib.platforms.linux;
    mainProgram = "free5gc-nef";
  };
})

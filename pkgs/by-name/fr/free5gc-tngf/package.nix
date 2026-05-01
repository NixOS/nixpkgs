{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:
buildGoModule (finalAttrs: {
  pname = "free5gc-tngf";
  version = "1.1.3";

  src = fetchFromGitHub {
    owner = "free5gc";
    repo = "tngf";
    tag = "v${finalAttrs.version}";
    hash = "sha256-rWSx4FCAA1QL7F66swPdhDcDr60TrtMnXhTlVBRR2OY=";
  };

  vendorHash = "sha256-C0zs4+ypC0LI5tkjrs5ajiWnoArHvdOoXj1iaNqSXM0=";

  ldflags = [
    "-X github.com/free5gc/util/version.VERSION=v${finalAttrs.version}"
  ];

  __structuredAttrs = true;

  doInstallCheck = true;

  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Open source 5G core network based on 3GPP R15";
    homepage = "https://free5gc.org/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ felbinger ];
    platforms = lib.platforms.linux;
  };
})

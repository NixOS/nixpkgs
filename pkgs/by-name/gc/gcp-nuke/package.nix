{
  lib,
  buildGoModule,
  fetchFromGitHub,
  stdenv,
  versionCheckHook,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "gcp-nuke";
  version = "1.11.6";

  src = fetchFromGitHub {
    owner = "ekristen";
    repo = "gcp-nuke";
    tag = "v${finalAttrs.version}";
    hash = "sha256-N/17XrIrfZJkcOov/HHzs6zFMSANkg8P/Clxpv2+ako=";
  };

  vendorHash = "sha256-ENshRfJO4ajMs6AsEWCWjQ6YOQFPrw5IcHhOeKdjtSA=";

  subPackages = [ "." ];

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/ekristen/gcp-nuke/pkg/common.VERSION=v${finalAttrs.version}"
    "-X=github.com/ekristen/gcp-nuke/pkg/common.SUMMARY=v${finalAttrs.version}"
  ];

  doCheck = false;

  doInstallCheck = true;

  nativeInstallCheckInputs = [
    versionCheckHook
  ];

  postInstallCheck = ''
    $out/bin/gcp-nuke resource-types | grep -q "."
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Remove all resources from a GCP Project";
    homepage = "https://github.com/ekristen/gcp-nuke";
    changelog = "https://github.com/ekristen/gcp-nuke/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    mainProgram = "gcp-nuke";
    maintainers = with lib.maintainers; [ caulagi ];
  };
})

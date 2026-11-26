{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nftables,
  nix-update-script,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "prometheus-nftables-exporter";
  version = "0.5.2";

  src = fetchFromGitHub {
    owner = "metal-stack";
    repo = "nftables-exporter";
    tag = "v${finalAttrs.version}";
    hash = "sha256-q/W36S26/WHCKAxFlvP658a3dnqBHw9NRkX22xRaBBQ=";
  };

  vendorHash = "sha256-pc82Xub0FMVkwwohPvR+NNd77qGTiPYtOPmORLifjuY=";

  __structuredAttrs = true;

  env.CGO_ENABLED = 0;

  # The nft path can still be overridden with `nft_location` in the config file.
  postPatch = ''
    substituteInPlace options.go \
      --replace-fail '"/sbin/nft"' '"${lib.getExe nftables}"'
  '';

  ldflags = [
    "-s"
    "-w"
    "-X github.com/metal-stack/v.Version=${finalAttrs.version}"
    "-X github.com/metal-stack/v.Revision=${finalAttrs.src.tag}"
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Prometheus exporter for nftables metrics";
    homepage = "https://github.com/metal-stack/nftables-exporter";
    changelog = "https://github.com/metal-stack/nftables-exporter/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl3Only;
    maintainers = [ ];
    mainProgram = "nftables-exporter";
    platforms = lib.platforms.linux;
  };
})

{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  pkg-config,
  btrfs-progs,
  gpgme,
  nix-update-script,
}:
buildGoModule (finalAttrs: {
  pname = "schedctl";
  version = "1.2.1";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "schedkit";
    repo = "schedctl";
    tag = "v${finalAttrs.version}";
    hash = "sha256-5LxD4420WCdHWcz7Yb0JV+ar4gSf/xsbkeHLPdLV1eY=";
  };

  vendorHash = "sha256-LMYJlvUmGejHk/AA/k2WwoI2Gtw3rNYgsklUcK+cB40=";
  proxyVendor = true;

  subPackages = [ "." ];

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    btrfs-progs
    gpgme
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/schedkit/schedctl/releases/tag/v${finalAttrs.version}";
    description = "OCI-packaged eBPF sched_ext plug and play schedulers for fun and profit";
    homepage = "https://github.com/schedkit";
    license = lib.licenses.asl20;
    mainProgram = "schedctl";
    maintainers = with lib.maintainers; [
      koalalorenzo
    ];
  };
})

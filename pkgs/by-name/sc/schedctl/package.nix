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
  version = "1.3.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "schedkit";
    repo = "schedctl";
    tag = "v${finalAttrs.version}";
    hash = "sha256-59m9hJjB2f6s+a4IgjppXRLpwXKEuXimiCl2Av6WXJ4=";
  };

  vendorHash = "sha256-ZjHa6frReZHnmnszEwO9SdGlWph1Fo5GxWC3UMCbs0Q=";
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
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      koalalorenzo
    ];
  };
})

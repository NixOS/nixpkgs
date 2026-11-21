{
  lib,
  rustPlatform,
  fetchFromGitHub,
  meta,
  mihomo,
  procps,
  replaceVars,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "clash-verge-service-ipc";
  version = "2.7.7";

  src = fetchFromGitHub {
    owner = "clash-verge-rev";
    repo = "clash-verge-service-ipc";
    tag = "v${finalAttrs.version}";
    hash = "sha256-2mkvc3VCozp/rpIYmb6QnAfsvJ7M97gEbT12bXFUVk4=";
  };

  patches = [
    ./patch-execution-lock.patch
    # Use the mihomo selected at package build time instead of the core copy
    # that upstream expects a privileged installer to stage under /var/lib.
    (replaceVars ./patch-packaged-core.patch {
      mihomo = lib.getExe mihomo;
    })
    # Let systemd's RuntimeDirectory and Group own the IPC socket access policy.
    ./patch-systemd-runtime-dir.patch
  ];

  cargoHash = "sha256-RhltLzbWX4K1nAGn9W808yoUF2qwCQPqZg2k5v9Ceag=";

  buildFeatures = [
    "standalone"
  ];

  nativeCheckInputs = [
    procps
  ];
  # build test helper binaries for tests
  preCheck = ''
    cargo build --features=standalone,test
  '';
  checkFeatures = [
    "standalone"
    "test"
    "client"
  ];
  inherit meta;
})

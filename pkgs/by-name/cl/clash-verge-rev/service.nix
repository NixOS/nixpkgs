{
  rustPlatform,
  fetchFromGitHub,
  meta,
  procps,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "clash-verge-service-ipc";
  version = "2.3.0";

  src = fetchFromGitHub {
    owner = "clash-verge-rev";
    repo = "clash-verge-service-ipc";
    # upstream uses branch
    rev = "21e661fa141e5ad3c705ee4cdb86efff8df6f769";
    hash = "sha256-XavlZWxuZKCTyIYpuXRvXpXCdakWhbLhOMmOrGBgDRo=";
  };

  patches = [
    # 1. Don't SetGID because the path is managed by systemd in NixOS, and we
    #    use different IPC path for sidecar mode. We can keep RestrictSUIDSGID
    #    in systemd serviceConfig.
    # 2. Set IPC socket path
    ./patch-service-directory.patch
  ];

  cargoHash = "sha256-WhH2o5wN5vYW8jZl+hWbnk1xqHu61ibAr4+/CI3YKHg=";

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

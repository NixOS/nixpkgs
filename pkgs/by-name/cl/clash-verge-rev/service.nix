{
  rustPlatform,
  fetchFromGitHub,
  meta,
  procps,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "clash-verge-service-ipc";
  version = "2.1.3";

  src = fetchFromGitHub {
    owner = "clash-verge-rev";
    repo = "clash-verge-service-ipc";
    # upstream uses branch
    rev = "a486e7df6ac3d641014085f43bd08e99ff09b5a2";
    hash = "sha256-WmQ3s6uED4Q1E2ORtjDqdxaUaPD+RIB5x8bYPOuGUSk=";
  };

  patches = [
    # 1. Don't SetGID because the path is managed by systemd in NixOS, and we
    #    use different IPC path for sidecar mode. We can keep RestrictSUIDSGID
    #    in systemd serviceConfig.
    # 2. Set IPC socket path
    ./patch-service-directory.patch
  ];

  cargoHash = "sha256-xE8ihRlox7qrmLHEGQ76pbisFj+1bqjwr+tllxLRDoA=";

  buildFeatures = [
    "standalone"
  ];

  nativeCheckInputs = [
    procps
  ];
  # build mock_binary for tests
  preCheck = ''
    cargo build --features=test
  '';
  checkFeatures = [
    "standalone"
    "test"
    "client"
  ];
  inherit meta;
})

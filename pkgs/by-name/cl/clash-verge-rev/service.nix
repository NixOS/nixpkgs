{
  stdenv,
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
    tag = "v${finalAttrs.version}";
    hash = "sha256-XavlZWxuZKCTyIYpuXRvXpXCdakWhbLhOMmOrGBgDRo=";
  };

  patches = [
    # Let the NixOS module's RuntimeDirectory/Group own socket access policy.
    # Upstream defaults target installer-managed /tmp paths and broad fallback
    # permissions, which do not fit the hardened systemd service.
    ./patch-service-directory.patch
  ];

  cargoHash = "sha256-WhH2o5wN5vYW8jZl+hWbnk1xqHu61ibAr4+/CI3YKHg=";

  buildFeatures = [
    "standalone"
  ];

  nativeCheckInputs = [
    procps
  ];
  # Upstream tests look in target/debug, while Nix builds under the target triple.
  preCheck = ''
    cargo build --features=test --bin mock_binary --bin crash_binary
    cargo build --features=standalone,test --bin owner_lock_holder

    mkdir -p target/debug
    for bin in mock_binary crash_binary owner_lock_holder; do
      ln -sf "../${stdenv.hostPlatform.config}/debug/$bin" "target/debug/$bin"
    done
  '';
  checkFeatures = [
    "standalone"
    "test"
    "client"
  ];
  inherit meta;
})

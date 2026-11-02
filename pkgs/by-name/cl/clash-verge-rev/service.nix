{
  rustPlatform,
  fetchFromGitHub,
  meta,
  procps,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "clash-verge-service-ipc";
  version = "2.7.6";

  src = fetchFromGitHub {
    owner = "clash-verge-rev";
    repo = "clash-verge-service-ipc";
    tag = "v${finalAttrs.version}";
    hash = "sha256-4YFRonC0nYuh16djiXuZszSoH06x49RVrtLcBnsI7VI=";
  };

  patches = [
    # Let the NixOS module's RuntimeDirectory/Group own socket access policy.
    # Upstream defaults target installer-managed /tmp paths and broad fallback
    # permissions, which do not fit the hardened systemd service.
    ./patch-service-directory.patch
  ];

  cargoHash = "sha256-Lx/Pj4Aev4aR0KQg/cdOXt+gx+s2XAgPG+mr+6w9dnY=";

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

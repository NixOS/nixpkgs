{
  rustPlatform,
  fetchFromGitHub,
  meta,
  procps,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "clash-verge-service-ipc";
  # Make sure it matches the version of clash_verge_rev_ipc referenced in clash-verge-rev
  version = "2.0.26";

  src = fetchFromGitHub {
    owner = "clash-verge-rev";
    repo = "clash-verge-service-ipc";
    # Use revision because version tag will be removed when a new version come out.
    rev = "37b9964a9bce767b5b95ea2be75613b23400c9f0";
    hash = "sha256-gc6SAjM248y3rIBDJYPAY4BCzkzZQVEws0M3CEDCdME=";
  };

  postPatch = ''
    # set socket path for service and test respectively
    sed -i "/not(feature = \"test\")))]/{n;s|/tmp/verge/clash-verge-service.sock|/run/clash-verge-rev/service.sock|}" src/lib.rs
    sed -i "/feature = \"test\", unix/{n;s|/tmp/verge/clash-verge-service.sock|/build/$sourceRoot/clash-verge-service-test.sock|}" src/lib.rs
  '';

  cargoHash = "sha256-31TzRk6kTSZMDy+EtjDHG9hScurlm9DL+neAbD6RgpU=";

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

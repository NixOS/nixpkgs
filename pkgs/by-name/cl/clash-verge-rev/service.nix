{
  rustPlatform,
  fetchFromGitHub,
  meta,
  procps,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "clash-verge-service-ipc";
  version = "2.3.3";

  src = fetchFromGitHub {
    owner = "clash-verge-rev";
    repo = "clash-verge-service-ipc";
    tag = "v${finalAttrs.version}";
    hash = "sha256-/kr0C+4bhal7DqKudtZvhPYUyn6xbxQw57g6ieJV64w=";
  };

  patches = [
    # Let the NixOS module's RuntimeDirectory/Group own socket access policy.
    # Upstream defaults target installer-managed /tmp paths and broad fallback
    # permissions, which do not fit the hardened systemd service.
    ./patch-service-directory.patch
  ];

  cargoHash = "sha256-2/lFfhP2414iiH+zG2TvNy6uaCzDldoo7sIfhKrQaFg=";

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

{
  stdenv,
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  bzip2,
  dbus,
  sqlite,
  nix-update-script,
  writableTmpDirAsHomeHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "lxmf-rs";
  version = "0.2.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "FreeTAKTeam";
    repo = "LXMF-rs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-2bxSBw4ISb7xOQiazrSVytvW9cW4i7azB7U8sos7+yA=";
  };

  cargoHash = "sha256-EqRL1JoAdyh46Ev8S/Ta6RsbhhaNH6dlisudpO2D1Rw=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    bzip2
    dbus
    sqlite
  ];

  env = {
    LIBSQLITE3_SYS_USE_PKG_CONFIG = true;
  };

  nativeCheckInputs = [
    writableTmpDirAsHomeHook
  ];

  __darwinAllowLocalNetworking = true;

  checkFlags = lib.optionals stdenv.hostPlatform.isDarwin [
    # assertion failed: matches
    "--skip=transport::announce_limits::tests::held_announces_evict_worst_entry_when_capacity_is_reached"
    "--skip=transport::announce_limits::tests::held_announces_release_lowest_hops_first"
    "--skip=transport::announce_limits::tests::ingress_limiting_is_scoped_per_interface"
    # multicast listener expected to see the Broadcast tx within 500ms
    "--skip=broadcast_tx_reaches_multicast_listeners"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Full port of Reticulum and LXMF to Rust with added SDK";
    homepage = "https://github.com/FreeTAKTeam/LXMF-rs";
    changelog = "https://github.com/FreeTAKTeam/LXMF-rs/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.epl20;
    maintainers = with lib.maintainers; [ drupol ];
    mainProgram = "lxmf-rs";
  };
})

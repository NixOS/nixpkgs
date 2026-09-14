{
  lib,
  fetchCrate,
  rustPlatform,
  nix-update-script,
  pkg-config,
  dbus,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "asahi-btsync";
  version = "0.2.6";

  src = fetchCrate {
    inherit (finalAttrs) pname version;
    hash = "sha256-hQE93lhD82gJaeVNtGQtIHIbyhrhfTsgY2FjClQ1QbE=";
  };

  cargoHash = "sha256-U1TOJO9LsT0Mu4HEjwFW0CKkuDkM1c4HdtHy0O4PaMM=";
  cargoDepsName = finalAttrs.pname;

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ dbus ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Tool to sync Bluetooth pairing keys with macos on ARM Macs";
    homepage = "https://crates.io/crates/asahi-btsync";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ lukaslihotzki ];
    mainProgram = "asahi-btsync";
    platforms = lib.platforms.linux;
  };
})

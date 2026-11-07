{
  lib,
  fetchCrate,
  rustPlatform,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "asahi-wifisync";
  version = "0.2.4";

  src = fetchCrate {
    inherit (finalAttrs) pname version;
    hash = "sha256-ifLXeT9J4J+ghli9QKX0PKrdQbNs/TwDFnKV5iurtgQ=";
  };

  cargoHash = "sha256-XSNpKRPtgoM3oDnCdnhVMzec0r7NzTg4ag+JKANoaWw=";
  cargoDepsName = finalAttrs.pname;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Tool to sync Wifi passwords with macos on ARM Macs";
    homepage = "https://crates.io/crates/asahi-wifisync";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ lukaslihotzki ];
    mainProgram = "asahi-wifisync";
    platforms = lib.platforms.linux;
  };
})

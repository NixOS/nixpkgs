{
  lib,
  rustPlatform,
  rosec,
  lld,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: rec {
  pname = "rosec-gnome-keyring";

  inherit (rosec) src version;

  sourceRoot = "${src.name}/rosec-gnome-keyring";

  cargoHash = "sha256-DaEdT/E4blOM/wFwuZoEuquwMgcSmTKlHT5CtSsqJ3g=";

  env.RUSTFLAGS = "-C linker=wasm-ld";
  nativeBuildInputs = [ lld ];

  passthru.updateScript = nix-update-script { };

  __structuredAttrs = true;

  meta = {
    description = "GNOME keyring provider for rosec";
    homepage = "https://github.com/jmylchreest/rosec";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ mikilio ];
    platforms = lib.platforms.wasi;
  };
})

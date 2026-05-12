{
  lib,
  rustPlatform,
  rustc,
  rosec,
  lld,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: rec {
  pname = "rosec-bitwarden-pm";

  inherit (rosec) src version;

  sourceRoot = "${src.name}/${pname}";

  cargoHash = "sha256-hNeCZPclwz2WMKnHsECBL0TduqkWsYhadEfsw54lGBg=";

  env.RUSTFLAGS = "-C linker=wasm-ld";
  nativeBuildInputs = [ lld ];

  passthru.updateScript = nix-update-script { };

  __structuredAttrs = true;

  meta = {
    description = "A Bitwarden (Personal) provider for rosec";
    homepage = "https://github.com/jmylchreest/rosec";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ mikilio ];
    platforms = lib.platforms.wasi;
  };
})

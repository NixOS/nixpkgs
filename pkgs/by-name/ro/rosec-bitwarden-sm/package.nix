{
  lib,
  rustPlatform,
  rustc,
  rosec,
  lld,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: rec {
  pname = "rosec-bitwarden-sm";

  inherit (rosec) src version;

  sourceRoot = "${src.name}/${pname}";

  cargoHash = "sha256-E4xxxK+7LEyYh7QtLnN8bHYwb2I9DQ7t4Inxbu72Fq4=";

  env.RUSTFLAGS = "-C linker=wasm-ld";
  nativeBuildInputs = [ lld ];

  passthru.updateScript = nix-update-script { };

  __structuredAttrs = true;

  meta = {
    description = "A Bitwarden Sercet Manager provider for rosec";
    homepage = "https://github.com/jmylchreest/rosec";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ mikilio ];
    platforms = lib.platforms.wasi;
  };
})

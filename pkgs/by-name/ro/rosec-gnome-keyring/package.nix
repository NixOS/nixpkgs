{
  lib,
  rustPlatform,
  rustc,
  rosec,
  lld,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: rec {
  pname = "rosec-gnome-keyring";

  inherit (rosec) src version;

  sourceRoot = "${src.name}/${pname}";

  cargoHash = "sha256-gkbD1N4veXhETwc5uzL/eq7a6naGq6suqJOAp53suFI=";

  env.RUSTFLAGS = "-C linker=wasm-ld";
  nativeBuildInputs = [ lld ];

  passthru.updateScript = nix-update-script { };

  __structuredAttrs = true;

  meta = {
    description = "A GNOME keyring provider for rosec";
    homepage = "https://github.com/jmylchreest/rosec";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ mikilio ];
    platforms = lib.platforms.wasi;
  };
})

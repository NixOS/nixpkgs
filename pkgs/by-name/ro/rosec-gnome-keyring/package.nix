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

  cargoHash = "sha256-puK69pWm+fCPjDgYJJKM/TDBC9/J9R1LGFxyUFYFLwg=";

  installPhase = ''
    runHook preInstall
    wasm=$(find target -type f \( -name rosec_gnome_keyring.wasm -o -name librosec_gnome_keyring.wasm \) -print -quit)
    test -n "$wasm"
    install -Dm644 "$wasm" "$out/lib/rosec/providers/${finalAttrs.passthru.rosecWasmFile}"
    install -Dm644 rosec_gnome_keyring.wasm.policy.toml \
      "$out/lib/rosec/providers/${finalAttrs.passthru.rosecWasmFile}.policy.toml"
    runHook postInstall
  '';

  passthru = {
    rosecWasmFile = "rosec_gnome_keyring.wasm";
    updateScript = nix-update-script { };
  };

  env.RUSTFLAGS = "-C linker=wasm-ld";
  nativeBuildInputs = [ lld ];

  __structuredAttrs = true;

  meta = {
    description = "GNOME keyring provider for rosec";
    homepage = "https://github.com/jmylchreest/rosec";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ mikilio ];
    platforms = lib.platforms.wasi;
  };
})

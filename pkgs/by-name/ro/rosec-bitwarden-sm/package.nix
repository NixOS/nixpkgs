{
  lib,
  rustPlatform,
  rosec,
  lld,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: rec {
  pname = "rosec-bitwarden-sm";

  inherit (rosec) src version;

  sourceRoot = "${src.name}/rosec-bitwarden-sm";

  cargoHash = "sha256-2I43Xf8TH1EL6hp/OgMljJwozac+dRMpeY4jCOyC2Wg=";

  installPhase = ''
    runHook preInstall
    wasm=$(find target -type f \( -name rosec_bitwarden_sm.wasm -o -name librosec_bitwarden_sm.wasm \) -print -quit)
    test -n "$wasm"
    install -Dm644 "$wasm" "$out/lib/rosec/providers/${finalAttrs.passthru.rosecWasmFile}"
    install -Dm644 rosec_bitwarden_sm.wasm.policy.toml \
      "$out/lib/rosec/providers/${finalAttrs.passthru.rosecWasmFile}.policy.toml"
    runHook postInstall
  '';

  passthru = {
    rosecWasmFile = "rosec_bitwarden_sm.wasm";
    updateScript = nix-update-script { };
  };

  env.RUSTFLAGS = "-C linker=wasm-ld";
  nativeBuildInputs = [ lld ];

  __structuredAttrs = true;

  meta = {
    description = "Bitwarden Secret Manager provider for rosec";
    homepage = "https://github.com/jmylchreest/rosec";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ mikilio ];
    platforms = lib.platforms.wasi;
  };
})

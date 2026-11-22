{
  lib,
  rustPlatform,
  rosec,
  lld,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: rec {
  pname = "rosec-bitwarden-pm";

  inherit (rosec) src version;

  sourceRoot = "${src.name}/rosec-bitwarden-pm";

  cargoHash = "sha256-8UdlzBe+igpM8OwtYCJDkm5NqEA01iGDrQVwaOQWJ+M=";

  # cargo's default install hook does not copy cdylib .wasm outputs.
  installPhase = ''
    runHook preInstall
    wasm=$(find target -type f \( -name rosec_bitwarden_pm.wasm -o -name librosec_bitwarden_pm.wasm \) -print -quit)
    test -n "$wasm"
    install -Dm644 "$wasm" "$out/lib/rosec/providers/${finalAttrs.passthru.rosecWasmFile}"
    install -Dm644 rosec_bitwarden_pm.wasm.policy.toml \
      "$out/lib/rosec/providers/${finalAttrs.passthru.rosecWasmFile}.policy.toml"
    runHook postInstall
  '';

  passthru = {
    rosecWasmFile = "rosec_bitwarden_pm.wasm";
    updateScript = nix-update-script { };
  };

  env.RUSTFLAGS = "-C linker=wasm-ld";
  nativeBuildInputs = [ lld ];

  __structuredAttrs = true;

  meta = {
    description = "Bitwarden (Personal) provider for rosec";
    homepage = "https://github.com/jmylchreest/rosec";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ mikilio ];
    platforms = lib.platforms.wasi;
  };
})

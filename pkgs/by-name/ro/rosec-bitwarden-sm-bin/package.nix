{
  lib,
  stdenv,
  fetchurl,
  rosec,
  nix-update-script,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "rosec-bitwarden-sm-bin";

  inherit (rosec) version;

  src = fetchurl {
    url = "https://github.com/jmylchreest/rosec/releases/download/v${finalAttrs.version}/rosec-provider-bitwarden-sm-${finalAttrs.version}.wasm.tar.gz";
    hash = "sha256-3XgJKSWWWgNpnv4v2CkVNuHCcdsxYMSI5iygNtp2ZeQ=";
  };

  sourceRoot = ".";

  dontStrip = true;

  installPhase = ''
    runHook preInstall
    install -Dm644 rosec_bitwarden_sm.wasm $out/lib/rosec/providers/rosec_bitwarden_sm.wasm
    install -Dm644 rosec_bitwarden_sm.wasm.policy.toml $out/lib/rosec/providers/rosec_bitwarden_sm.wasm.policy.toml
    install -Dm644 rosec_bitwarden_sm.wasm.minisig $out/lib/rosec/providers/rosec_bitwarden_sm.wasm.minisig
    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Bitwarden Secret Manager provider for rosec (prebuilt)";
    homepage = "https://github.com/jmylchreest/rosec";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ mikilio ];
    platforms = lib.platforms.all;
  };
})

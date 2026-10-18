{
  lib,
  stdenv,
  fetchurl,
  rosec,
  nix-update-script,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "rosec-bitwarden-pm-bin";

  inherit (rosec) version;

  src = fetchurl {
    url = "https://github.com/jmylchreest/rosec/releases/download/v${finalAttrs.version}/rosec-provider-bitwarden-pm-${finalAttrs.version}.wasm.tar.gz";
    hash = "sha256-EqkoCbsEfg3HPX2Si+67EhoI2ivoayx7LPVZSScoVQA=";
  };

  sourceRoot = ".";

  dontStrip = true;

  installPhase = ''
    runHook preInstall
    install -Dm644 rosec_bitwarden_pm.wasm $out/lib/rosec/providers/rosec_bitwarden_pm.wasm
    install -Dm644 rosec_bitwarden_pm.wasm.policy.toml $out/lib/rosec/providers/rosec_bitwarden_pm.wasm.policy.toml
    install -Dm644 rosec_bitwarden_pm.wasm.minisig $out/lib/rosec/providers/rosec_bitwarden_pm.wasm.minisig
    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Bitwarden (Personal) provider for rosec (prebuilt)";
    homepage = "https://github.com/jmylchreest/rosec";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ mikilio ];
    platforms = lib.platforms.all;
  };
})

{
  lib,
  stdenv,
  fetchurl,
  rosec,
  nix-update-script,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "rosec-gnome-keyring-bin";

  inherit (rosec) version;

  src = fetchurl {
    url = "https://github.com/jmylchreest/rosec/releases/download/v${finalAttrs.version}/rosec-provider-gnome-keyring-${finalAttrs.version}.wasm.tar.gz";
    hash = "sha256-gvuFG6Gf5b7lO19502T6r7iKtXcn6CICR+Xl1BA/Dr0=";
  };

  sourceRoot = ".";

  dontStrip = true;

  installPhase = ''
    runHook preInstall
    install -Dm644 rosec_gnome_keyring.wasm $out/lib/rosec/providers/rosec_gnome_keyring.wasm
    install -Dm644 rosec_gnome_keyring.wasm.policy.toml $out/lib/rosec/providers/rosec_gnome_keyring.wasm.policy.toml
    install -Dm644 rosec_gnome_keyring.wasm.minisig $out/lib/rosec/providers/rosec_gnome_keyring.wasm.minisig
    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "GNOME keyring provider for rosec (prebuilt)";
    homepage = "https://github.com/jmylchreest/rosec";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ mikilio ];
    platforms = lib.platforms.all;
  };
})

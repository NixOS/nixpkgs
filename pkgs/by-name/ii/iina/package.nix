{
  lib,
  fetchurl,
  stdenvNoCC,
  undmg,
  nix-update-script,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "iina";
  version = "1.4.4";

  src = fetchurl {
    url = "https://github.com/iina/iina/releases/download/v${finalAttrs.version}/IINA.v${finalAttrs.version}.dmg";
    hash = "sha256-3Q/AvUs3+1ehyNMNbjIBs6ZLr9KZWf5WlTlkYTI3vrE=";
  };

  nativeBuildInputs = [ undmg ];

  sourceRoot = "IINA.app";

  installPhase = ''
    mkdir -p $out/{bin,Applications/IINA.app}
    cp -R . "$out/Applications/IINA.app"
    ln -s "$out/Applications/IINA.app/Contents/MacOS/iina-cli" "$out/bin/iina"
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/iina/iina/releases/tag/v${finalAttrs.version}";
    description = "Modern media player for macOS";
    homepage = "https://iina.io/";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [
      arkivm
      FlameFlag
      kinnrai
      stepbrobd
    ];
    mainProgram = "iina";
    platforms = lib.platforms.darwin;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})

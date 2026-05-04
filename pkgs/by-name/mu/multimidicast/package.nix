{
  lib,
  stdenv,
  fetchzip,
  alsa-lib,
  nix-update-script,
}:
stdenv.mkDerivation (finalAttrs: {
  name = "multimidicast";
  version = "1.4";

  src = fetchzip {
    url = "https://llg.cubic.org/tools/multimidicast/multimidicast-${finalAttrs.version}.tar.gz";
    hash = "sha256-fuZKl9C5kr4bodVz+QsYbSTmWmsWNTiFU2eeYR9hw6Y=";
  };

  strictDeps = true;

  buildInputs = [ alsa-lib ];

  installPhase = ''
    runHook preInstall
    install -Dm 755 multimidicast -t $out/bin
    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Sends and receives MIDI from Alsa sequencers over your network";
    homepage = "https://llg.cubic.org/tools/multimidicast";
    license = lib.licenses.free;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ mrtnvgr ];
  };
})

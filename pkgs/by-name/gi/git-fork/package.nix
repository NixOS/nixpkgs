{
  lib,
  stdenv,
  fetchurl,
  undmg,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "git-fork";
  version = "2.70.2";
  src = fetchurl {
    url = "https://cdn.fork.dev/mac/Fork-${finalAttrs.version}.dmg";
    hash = "sha256-frIqJ6EfAX1bP/rEZQrB60cWK/hR/0PkQl6RMwMiJXE=";
  };

  sourceRoot = ".";

  nativeBuildInputs = [ undmg ];

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/"{bin,Applications}
    mv Fork.app "$out/Applications/"
    ln -s "$out/Applications/Fork.app/Contents/Resources/fork_cli" "$out/bin/fork"

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Git client";
    homepage = "https://git-fork.com";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ dudeofawesome ];
    platforms = lib.platforms.darwin;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    mainProgram = "fork";
  };
})

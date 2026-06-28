{
  lib,
  stdenvNoCC,
  bash,
  makeWrapper,
  runCommand,
  nixosTests,
  playerctl,
  pulseaudio,
  gawk,
  coreutils,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "spotify-ad-muter";
  version = "1.0.0";

  __structuredAttrs = true;
  strictDeps = true;

  src = ./spotify-ad-muter.sh;
  dontUnpack = true;

  nativeBuildInputs = [ makeWrapper ];

  runtimeInputs = [
    playerctl
    pulseaudio
    gawk
    coreutils
  ];

  installPhase = ''
    runHook preInstall

    install -Dm755 $src $out/bin/.spotify-ad-muter-wrapped
    substituteInPlace $out/bin/.spotify-ad-muter-wrapped \
      --replace-fail "#!/usr/bin/env bash" "#!${lib.getExe bash}"
    makeWrapper $out/bin/.spotify-ad-muter-wrapped $out/bin/spotify-ad-muter \
      --prefix PATH : ${lib.makeBinPath finalAttrs.runtimeInputs}

    runHook postInstall
  '';

  passthru.tests = {
    inherit (nixosTests) spotify-ad-muter;

    smoke = runCommand "${finalAttrs.pname}-smoke-test" { } ''
      export XDG_RUNTIME_DIR=$TMPDIR/runtime
      export HOME=$TMPDIR/home
      mkdir -p "$XDG_RUNTIME_DIR" "$HOME"

      ${lib.getExe finalAttrs.finalPackage} --restore

      touch $out
    '';
  };

  meta = {
    description = "Automatically mute Spotify advertisements";
    homepage = "https://github.com/Luna5akura/Luna-Nix-Configuration";
    license = lib.licenses.mit;
    mainProgram = "spotify-ad-muter";
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ luna5akura ];
  };
})

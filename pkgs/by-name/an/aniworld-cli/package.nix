{
  fetchFromGitHub,
  makeWrapper,
  stdenvNoCC,
  lib,
  gnugrep,
  gnused,
  curl,
  catt,
  syncplay,
  ffmpeg,
  fzf,
  aria2,
  mpv,
  vlc,
  iina,
  withMpv ? true,
  withVlc ? false,
  withIina ? false,
  chromecastSupport ? false,
  syncSupport ? false,
}:

let
  players = lib.optional withMpv mpv ++ lib.optional withVlc vlc ++ lib.optional withIina iina;
in

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "aniworld-cli";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "dxmoc";
    repo = "aniworld-cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-6kO5FYXkQ9WAU4sAT3Fsrge6qFiIvFmGTPYPAbIFi18=";
  };

  nativeBuildInputs = [ makeWrapper ];
  runtimeInputs = [
    gnugrep
    gnused
    curl
    fzf
    ffmpeg
    aria2
  ]
  ++ lib.optional chromecastSupport catt
  ++ lib.optional syncSupport syncplay;

  installPhase = ''
    runHook preInstall

    install -Dm755 aniworld-cli $out/bin/aniworld-cli
    cp -r lib $out/bin/lib

    wrapProgram $out/bin/aniworld-cli \
      --prefix PATH : ${lib.makeBinPath finalAttrs.runtimeInputs} \
      ${lib.optionalString (builtins.length players > 0) "--suffix PATH : ${lib.makeBinPath players}"}

    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/dxmoc/aniworld-cli";
    description = "CLI tool for streaming German anime - Fork of ani-cli";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      v3rm1n0
    ];
    platforms = lib.platforms.unix;
    mainProgram = "aniworld-cli";
    sourceProvenance = with lib.sourceTypes; [
      fromSource
    ];
  };
})

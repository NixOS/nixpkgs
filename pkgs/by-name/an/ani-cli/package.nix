{
  fetchFromGitHub,
  makeWrapper,
  stdenvNoCC,
  lib,
  gnugrep,
  gnused,
  curl-impersonate,
  catt,
  syncplay,
  ffmpeg,
  fzf,
  yt-dlp,
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
  pname = "ani-cli";
  version = "5.0";

  src = fetchFromGitHub {
    owner = "pystardust";
    repo = "ani-cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-rRQESi0Skoyf1jy/dRRK6ooKRPQhkak107kk5ulwZYI=";
  };

  nativeBuildInputs = [ makeWrapper ];
  runtimeInputs = [
    gnugrep
    gnused
    curl-impersonate
    fzf
    ffmpeg
    yt-dlp
  ]
  ++ lib.optional chromecastSupport catt
  ++ lib.optional syncSupport syncplay;

  strictDeps = true;
  __structuredAttrs = true;

  installPhase = ''
    runHook preInstall

    install -Dm755 ani-cli $out/bin/ani-cli

    wrapProgram $out/bin/ani-cli \
      --prefix PATH : ${lib.makeBinPath finalAttrs.runtimeInputs} \
      ${lib.optionalString (builtins.length players > 0) "--suffix PATH : ${lib.makeBinPath players}"}

    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/pystardust/ani-cli";
    description = "Cli tool to browse and play anime";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ skykanin ];
    platforms = lib.platforms.unix;
    mainProgram = "ani-cli";
    sourceProvenance = with lib.sourceTypes; [
      fromSource
    ];
  };
})

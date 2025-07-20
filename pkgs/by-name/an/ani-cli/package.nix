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
  pname = "ani-cli";
  version = "4.10";

  src = fetchFromGitHub {
    owner = "pystardust";
    repo = "ani-cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-R/YQ02ctTcAEzrVyWlaCHi1YW82iPrMBbbMNP21r0p8=";
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
    maintainers = with lib.maintainers; [
      skykanin
      diniamo
    ];
    platforms = lib.platforms.unix;
    mainProgram = "ani-cli";
  };
})

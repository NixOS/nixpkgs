{
  stdenv,
  pname,
  meta,
  fetchurl,
  undmg,
  updateScript,
  lib,
}:

stdenv.mkDerivation {
  inherit pname;

  version = "1.2.75.510";

  src =
    # WARNING: This Wayback Machine URL redirects to the closest timestamp.
    # Future maintainers must manually check the timestamp exists and exactly matches at:
    # https://web.archive.org/web/*/https://download.scdn.co/SpotifyARM64.dmg
    # https://web.archive.org/web/*/https://download.scdn.co/Spotify.dmg
    if stdenv.hostPlatform.isAarch64 then
      (fetchurl {
        url = "https://web.archive.org/web/20251029235406/https://download.scdn.co/SpotifyARM64.dmg";
        hash = "sha256-gEZxRBT7Jo2m6pirf+CreJiMeE2mhIkpe9Mv5t0RI58=";
      })
    else
      (fetchurl {
        url = "https://web.archive.org/web/20251029235833/https://download.scdn.co/Spotify.dmg";
        hash = "sha256-fhQYm7yMrlvY57gMuWGU31EbWidZ2l9bd44mhokZKTw=";
      });

  nativeBuildInputs = [ undmg ];

  sourceRoot = ".";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/Applications
    cp -r *.app $out/Applications

    runHook postInstall
  '';

  passthru = { inherit updateScript; };

  meta = meta // {
    maintainers = with lib.maintainers; [
      matteopacini
      Enzime
    ];
  };
}

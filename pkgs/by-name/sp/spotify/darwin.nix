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

<<<<<<< HEAD
  version = "1.2.78.418";
=======
  version = "1.2.75.510";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src =
    # WARNING: This Wayback Machine URL redirects to the closest timestamp.
    # Future maintainers must manually check the timestamp exists and exactly matches at:
    # https://web.archive.org/web/*/https://download.scdn.co/SpotifyARM64.dmg
    # https://web.archive.org/web/*/https://download.scdn.co/Spotify.dmg
    if stdenv.hostPlatform.isAarch64 then
      (fetchurl {
<<<<<<< HEAD
        url = "https://web.archive.org/web/20251212105149/https://download.scdn.co/SpotifyARM64.dmg";
        hash = "sha256-/rrThZOpjzaHPX1raDe5X8PqtJeTI4GDS5sXSfthXTQ=";
      })
    else
      (fetchurl {
        url = "https://web.archive.org/web/20251212105140/https://download.scdn.co/Spotify.dmg";
        hash = "sha256-N2tQTS9vHp93cRI0c5riVZ/8FSaq3ovDqh5K9aU6jV0=";
=======
        url = "https://web.archive.org/web/20251029235406/https://download.scdn.co/SpotifyARM64.dmg";
        hash = "sha256-gEZxRBT7Jo2m6pirf+CreJiMeE2mhIkpe9Mv5t0RI58=";
      })
    else
      (fetchurl {
        url = "https://web.archive.org/web/20251029235833/https://download.scdn.co/Spotify.dmg";
        hash = "sha256-fhQYm7yMrlvY57gMuWGU31EbWidZ2l9bd44mhokZKTw=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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

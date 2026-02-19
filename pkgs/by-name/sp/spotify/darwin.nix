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

  version = "1.2.78.418";

  src =
    # WARNING: This Wayback Machine URL redirects to the closest timestamp.
    # Future maintainers must manually check the timestamp exists and exactly matches at:
    # https://web.archive.org/web/*/https://download.scdn.co/SpotifyARM64.dmg
    # https://web.archive.org/web/*/https://download.scdn.co/Spotify.dmg
    if stdenv.hostPlatform.isAarch64 then
      (fetchurl {
        url = "https://web.archive.org/web/20251212105149/https://download.scdn.co/SpotifyARM64.dmg";
        hash = "sha256-/rrThZOpjzaHPX1raDe5X8PqtJeTI4GDS5sXSfthXTQ=";
      })
    else
      (fetchurl {
        url = "https://web.archive.org/web/20251212105140/https://download.scdn.co/Spotify.dmg";
        hash = "sha256-N2tQTS9vHp93cRI0c5riVZ/8FSaq3ovDqh5K9aU6jV0=";
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

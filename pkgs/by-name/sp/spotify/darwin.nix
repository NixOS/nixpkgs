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

  version = "1.2.84.476";

  src =
    # WARNING: This Wayback Machine URL redirects to the closest timestamp.
    # Future maintainers must manually check the timestamp exists and exactly matches at:
    # https://web.archive.org/web/*/https://download.scdn.co/SpotifyARM64.dmg
    # https://web.archive.org/web/*/https://download.scdn.co/Spotify.dmg
    if stdenv.hostPlatform.isAarch64 then
      (fetchurl {
        url = "https://web.archive.org/web/20260228212834/https://download.scdn.co/SpotifyARM64.dmg";
        hash = "sha256-Zj5qATaW1QPTInC/Y/jZx2xq5eHG/OQixpj8DWUpEXY=";
      })
    else
      (fetchurl {
        url = "https://web.archive.org/web/20260228213541/https://download.scdn.co/Spotify.dmg";
        hash = "sha256-4Lm4g0gAQ3EA7Sj2wDTbjEXRxcNoGWHLvdEx/57nry4=";
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

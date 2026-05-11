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

  version = "1.2.89.539";

  src =
    # WARNING: This Wayback Machine URL redirects to the closest timestamp.
    # Future maintainers must manually check the timestamp exists and exactly matches at:
    # https://web.archive.org/web/*/https://download.scdn.co/SpotifyARM64.dmg
    # https://web.archive.org/web/*/https://download.scdn.co/Spotify.dmg
    if stdenv.hostPlatform.isAarch64 then
      (fetchurl {
        url = "https://web.archive.org/web/20260510001507/https://download.scdn.co/SpotifyARM64.dmg";
        hash = "sha256-m7Wbcl1ewIa92n/eCTgF62EN63KJyWPRW2ZF71/8btk=";
      })
    else
      (fetchurl {
        url = "https://web.archive.org/web/20260510001458/https://download.scdn.co/Spotify.dmg";
        hash = "sha256-BjZ0WT00QvLQvLBWnHzE/POf82cUxZUW4BIJsk2hAaw=";
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

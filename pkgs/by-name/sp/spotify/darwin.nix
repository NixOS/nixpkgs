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

  version = "1.2.92.147";

  src =
    # WARNING: This Wayback Machine URL redirects to the closest timestamp.
    # Future maintainers must manually check the timestamp exists and exactly matches at:
    # https://web.archive.org/web/*/https://download.scdn.co/SpotifyARM64.dmg
    # https://web.archive.org/web/*/https://download.scdn.co/Spotify.dmg
    if stdenv.hostPlatform.isAarch64 then
      (fetchurl {
        url = "https://web.archive.org/web/20260607203830/https://download.scdn.co/SpotifyARM64.dmg";
        hash = "sha256-rQuvF7LWHBR3q8GJQWO671n1NRDKinQps+zYfXPktrU=";
      })
    else
      (fetchurl {
        url = "https://web.archive.org/web/20260607203705/https://download.scdn.co/Spotify.dmg";
        hash = "sha256-jX7nBPiwxnKXWpN4/XiXKBl6Eg01954+VDwWRoJfdbk=";
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

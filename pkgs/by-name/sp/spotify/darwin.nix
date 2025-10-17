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

  version = "1.2.74.477";

  src =
    # WARNING: This Wayback Machine URL redirects to the closest timestamp.
    # Future maintainers must manually check the timestamp exists and exactly matches at:
    # https://web.archive.org/web/*/https://download.scdn.co/SpotifyARM64.dmg
    # https://web.archive.org/web/*/https://download.scdn.co/Spotify.dmg
    if stdenv.hostPlatform.isAarch64 then
      (fetchurl {
        url = "https://web.archive.org/web/20251010104459/https://download.scdn.co/SpotifyARM64.dmg";
        hash = "sha256-0gwoptqLBJBM0qJQ+dGAZdCD6WXzDJEs0BfOxz7f2nQ=";
      })
    else
      (fetchurl {
        url = "https://web.archive.org/web/20251010104433/https://download.scdn.co/Spotify.dmg";
        hash = "sha256-8CrhLbnswbuAjRMaan2cTnnOMsr3vpW92IQ00KwPUHo=";
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
      iedame
    ];
  };
}

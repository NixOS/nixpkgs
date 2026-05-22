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

  version = "1.2.88.483";

  src =
    # WARNING: This Wayback Machine URL redirects to the closest timestamp.
    # Future maintainers must manually check the timestamp exists and exactly matches at:
    # https://web.archive.org/web/*/https://download.scdn.co/SpotifyARM64.dmg
    # https://web.archive.org/web/*/https://download.scdn.co/Spotify.dmg
    if stdenv.hostPlatform.isAarch64 then
      (fetchurl {
        url = "https://web.archive.org/web/20260501151114/https://download.scdn.co/SpotifyARM64.dmg";
        hash = "sha256-rBoJ5PKge4pr90FqYwsG+6JqyKvc3sKyPXM7OXXEmz8=";
      })
    else
      (fetchurl {
        url = "https://web.archive.org/web/20260501151019/https://download.scdn.co/Spotify.dmg";
        hash = "sha256-o/qDYnVhkrca2TBDoqxsKWq0QfDQyHdhU4llbmIGUBQ=";
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

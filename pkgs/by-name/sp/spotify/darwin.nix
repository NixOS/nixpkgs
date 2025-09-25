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

  version = "1.2.72.438";

  src =
    # WARNING: This Wayback Machine URL redirects to the closest timestamp.
    # Future maintainers must manually check the timestamp exists and exactly matches at:
    # https://web.archive.org/web/*/https://download.scdn.co/SpotifyARM64.dmg
    # https://web.archive.org/web/*/https://download.scdn.co/Spotify.dmg
    if stdenv.hostPlatform.isAarch64 then
      (fetchurl {
        url = "https://web.archive.org/web/20250912003756/https://download.scdn.co/SpotifyARM64.dmg";
        hash = "sha256-K+dwlT4hd/SWbQT23ESZY8gGQ8bf5x5CpepMz5Wd6Ng=";
      })
    else
      (fetchurl {
        url = "https://web.archive.org/web/20250912003614/https://download.scdn.co/Spotify.dmg";
        hash = "sha256-qGoU8wWfuGvAZR4/998kvoPTqkaJPHASTRyZL8Kitzs=";
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

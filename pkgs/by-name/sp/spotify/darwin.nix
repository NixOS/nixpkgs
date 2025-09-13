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

  version = "1.2.70.409";

  src =
    # WARNING: This Wayback Machine URL redirects to the closest timestamp.
    # Future maintainers must manually check the timestamp exists.
    if stdenv.hostPlatform.isAarch64 then
      (fetchurl {
        url = "https://web.archive.org/web/20250829211423/https://download.scdn.co/SpotifyARM64.dmg";
        hash = "sha256-fTyACxbyIgg7EwIgnNvNerJGUwAVLP2bg0TMnOegWeQ=";
      })
    else
      (fetchurl {
        url = "https://web.archive.org/web/20250826093142/https://download.scdn.co/Spotify.dmg";
        hash = "sha256-i1mHX7zo/07sHrGm8c6SQdFekRuJXOmqCcOk2IYPeLI=";
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

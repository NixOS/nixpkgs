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
    if stdenv.hostPlatform.isAarch64 then
      (fetchurl {
        url = "https://web.archive.org/web/20250826093914/https://download.scdn.co/SpotifyARM64.dmg";
        hash = "sha256-bs+rSMfIFG0FyHGDUtuk6tSbd5l6r6qUNH20hQQjZC0=";
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

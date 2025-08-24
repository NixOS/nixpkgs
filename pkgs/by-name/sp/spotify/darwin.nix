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

  version = "1.2.69.449";

  src =
    if stdenv.hostPlatform.isAarch64 then
      (fetchurl {
        url = "https://web.archive.org/web/20250811170447/https://download.scdn.co/SpotifyARM64.dmg";
        hash = "sha256-x9lpcQI1kZc4OIvQBhKXmI7t/2DIDbzufZhpNCKTxPA=";
      })
    else
      (fetchurl {
        url = "https://web.archive.org/web/20250811170211/https://download.scdn.co/Spotify.dmg";
        hash = "sha256-z6pmQ3Wmwnd3YQNf1WPdPNCRxHX1PjqAEt50trGe0Bk=";
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

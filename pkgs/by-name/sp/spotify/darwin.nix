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

  version = "1.2.64.408";

  src =
    if stdenv.hostPlatform.isAarch64 then
      (fetchurl {
        url = "https://web.archive.org/web/20250522123639/https://download.scdn.co/SpotifyARM64.dmg";
        hash = "sha256-28T+AxhnM1K6W50JUu9RdFRKsBRDTQulKK2+kk2RTMQ=";
      })
    else
      (fetchurl {
        url = "https://web.archive.org/web/20250522130546/https://download.scdn.co/Spotify.dmg";
        hash = "sha256-P8itkT2w7xQl0WfMLcNHgi1zcoYMqOdGmNDXdwhZBUs=";
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

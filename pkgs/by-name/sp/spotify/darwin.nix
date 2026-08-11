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

  version = "1.2.94.583";

  # WARNING: This Wayback Machine URL redirects to the closest timestamp.
  # Future maintainers must manually check the timestamp exists and exactly matches at:
  # https://web.archive.org/web/*/https://download.scdn.co/SpotifyARM64.dmg
  src = fetchurl {
    url = "https://web.archive.org/web/20260712124054/https://download.scdn.co/SpotifyARM64.dmg";
    hash = "sha256-euPw73U9VWSppHFoB8JPHqOFFop66S0bbcVaJty/gY4=";
  };

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

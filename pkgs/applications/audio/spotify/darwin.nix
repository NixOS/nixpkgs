{ stdenv
, pname
, meta
, fetchurl
, undmg
, lib
}:

stdenv.mkDerivation {
  inherit pname;

  version = "1.1.97.962.g24733a46";

  src = if stdenv.isAarch64 then (
    fetchurl {
      url = "https://web.archive.org/web/20221101120432/https://download.scdn.co/SpotifyARM64.dmg";
      sha256 = "sha256-8WDeVRgaZXuUa95PNa15Cuul95ynklBaZpuq+U1eGTU=";
    })
  else (
    fetchurl {
      url = "https://web.archive.org/web/20221101120647/https://download.scdn.co/Spotify.dmg";
      sha256 = "sha256-uPpD8Hv70FlaSjtt9rq5ntI64agxG8+/LNEvRe4ocJ4=";
    });

  nativeBuildInputs = [ undmg ];

  sourceRoot = ".";

  installPhase = ''
    mkdir -p $out/Applications
    cp -r *.app $out/Applications
  '';

  meta = meta // {
    maintainers = with lib.maintainers; [ Enzime ];
  };
}

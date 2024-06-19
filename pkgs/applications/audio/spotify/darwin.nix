{ stdenv
, pname
, meta
, fetchurl
, undmg
, lib
}:

stdenv.mkDerivation {
  inherit pname;

  version = "1.2.38.720.ga4a70a0e";

  src = if stdenv.isAarch64 then (
    fetchurl {
      url = "https://web.archive.org/web/20240601115919/https://download.scdn.co/SpotifyARM64.dmg";
      sha256 = "sha256-jQt5lmquxHU6jw1vtEoTsbwryv/6XBZQ2IT7KobKYvk=";
    })
  else (
    fetchurl {
      url = "https://web.archive.org/web/20240601115919/https://download.scdn.co/Spotify.dmg";
      sha256 = "sha256-1IVIZpwlwlIjl/UeSyYOQOrQk7sMxrHCQsCkcVMqcfo=";
    });

  nativeBuildInputs = [ undmg ];

  sourceRoot = ".";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/Applications
    cp -r *.app $out/Applications

    runHook postInstall
  '';

  meta = meta // {
    maintainers = with lib.maintainers; [ Enzime ];
  };
}

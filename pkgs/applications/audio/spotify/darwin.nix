{ stdenv
, pname
, meta
, fetchurl
, undmg
, lib
}:

stdenv.mkDerivation {
  inherit pname;

  version = "1.2.17.834.g26ee1129";

  src = if stdenv.isAarch64 then (
    fetchurl {
      url = "https://web.archive.org/web/20230808124344/https://download.scdn.co/SpotifyARM64.dmg";
      sha256 = "sha256-u22hIffuCT6DwN668TdZXYedY9PSE7ZnL+ITK78H7FI=";
    })
  else (
    fetchurl {
      url = "https://web.archive.org/web/20230808124637/https://download.scdn.co/Spotify.dmg";
      sha256 = "sha256-aaYMbZpa2LvyBeXmEAjrRYfYqbudhJHR/hvCNTsNQmw=";
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

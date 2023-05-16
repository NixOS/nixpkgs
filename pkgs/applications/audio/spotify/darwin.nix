{ stdenv
, pname
, meta
, fetchurl
, undmg
, lib
}:

stdenv.mkDerivation {
  inherit pname;

<<<<<<< HEAD
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
=======
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
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    });

  nativeBuildInputs = [ undmg ];

  sourceRoot = ".";

  installPhase = ''
<<<<<<< HEAD
    runHook preInstall

    mkdir -p $out/Applications
    cp -r *.app $out/Applications

    runHook postInstall
=======
    mkdir -p $out/Applications
    cp -r *.app $out/Applications
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  '';

  meta = meta // {
    maintainers = with lib.maintainers; [ Enzime ];
  };
}

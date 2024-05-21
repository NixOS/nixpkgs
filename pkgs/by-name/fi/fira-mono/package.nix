{ lib, stdenvNoCC, fetchzip }:

stdenvNoCC.mkDerivation rec {
  pname = "fira-mono";
  version = "4.202";

  src = fetchzip {
    url = "https://github.com/mozilla/Fira/archive/${version}.zip";
    hash = "sha256-HLReqgL0PXF5vOpwLN0GiRwnzkjGkEVEyOEV2Z4R0oQ=";
  };

  installPhase = ''
    runHook preInstall

    install -Dm644 otf/FiraMono*.otf -t $out/share/fonts/opentype

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://mozilla.github.io/Fira/";
    description = "Monospace font for Firefox OS";
    longDescription = ''
      Fira Mono is a monospace font designed by Erik Spiekermann,
      Ralph du Carrois, Anja Meiners and Botio Nikoltchev of Carrois
      Type Design for Mozilla Firefox OS. Available in Regular,
      Medium, and Bold.
    '';
    license = licenses.ofl;
    maintainers = [ maintainers.rycee ];
    platforms = platforms.all;
  };
}

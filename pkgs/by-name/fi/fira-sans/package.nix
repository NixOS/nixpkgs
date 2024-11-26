{ lib
, stdenvNoCC
, fetchzip
}:

stdenvNoCC.mkDerivation rec {
  pname = "fira-sans";
  version = "4.301";

  src = fetchzip {
    url = "https://bboxtype.com/downloads/Fira/Download_Folder_FiraSans_${lib.replaceStrings ["."] [""] version}.zip";
    hash = "sha256-WBt3oqPK7ACqMhilYkyFx9Ek2ugwdCDFZN+8HLRnGRs";
    stripRoot = false;
  };

  installPhase = ''
    runHook preInstall

    install --mode=-x -Dt $out/share/fonts/opentype Download_Folder_FiraSans*/Fonts/Fira_Sans_OTF*/*/*/*.otf

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://bboxtype.com/fira/";
    description = "Sans-serif font for Firefox OS";
    longDescription = ''
      Fira Sans is a sans-serif font designed by Erik Spiekermann,
      Ralph du Carrois, Anja Meiners and Botio Nikoltchev of Carrois
      Type Design for Mozilla Firefox OS.  It is closely related to
      Spiekermann's FF Meta typeface.  Available in Two, Four, Eight,
      Hair, Thin, Ultra Light, Extra Light, Light, Book, Regular,
      Medium, Semi Bold, Bold, Extra Bold, Heavy weights with
      corresponding italic versions.
    '';
    license = licenses.ofl;
    platforms = platforms.all;
  };
}

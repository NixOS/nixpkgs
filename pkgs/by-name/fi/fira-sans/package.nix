{
  lib,
  stdenvNoCC,
  fetchzip,
}:

stdenvNoCC.mkDerivation rec {
  pname = "fira-sans";
  version = "4.301";

  src = fetchzip {
<<<<<<< HEAD
    url = "https://carrois.com/downloads/Fira/Download_Folder_FiraSans_${
=======
    url = "https://bboxtype.com/downloads/Fira/Download_Folder_FiraSans_${
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      lib.replaceStrings [ "." ] [ "" ] version
    }.zip";
    hash = "sha256-WBt3oqPK7ACqMhilYkyFx9Ek2ugwdCDFZN+8HLRnGRs";
    stripRoot = false;
  };

  installPhase = ''
    runHook preInstall

<<<<<<< HEAD
    install --mode=644 -Dt $out/share/fonts/opentype Download_Folder_FiraSans*/Fonts/Fira_Sans_OTF*/*/*/*.otf
=======
    install --mode=-x -Dt $out/share/fonts/opentype Download_Folder_FiraSans*/Fonts/Fira_Sans_OTF*/*/*/*.otf
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

    runHook postInstall
  '';

<<<<<<< HEAD
  meta = {
    homepage = "https://carrois.com/fira/";
=======
  meta = with lib; {
    homepage = "https://bboxtype.com/fira/";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
<<<<<<< HEAD
    license = lib.licenses.ofl;
    platforms = lib.platforms.all;
=======
    license = licenses.ofl;
    platforms = platforms.all;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}

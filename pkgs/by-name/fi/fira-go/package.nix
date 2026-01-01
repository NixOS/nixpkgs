{
  lib,
  stdenvNoCC,
  fetchzip,
}:

<<<<<<< HEAD
stdenvNoCC.mkDerivation rec {
=======
stdenvNoCC.mkDerivation {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pname = "fira-go";
  version = "1.001";

  src = fetchzip {
<<<<<<< HEAD
    url = "https://carrois.com/downloads/FiraGO/Download_Folder_FiraGO_${
      lib.replaceStrings [ "." ] [ "" ] version
    }.zip";
    hash = "sha256-+lw4dh7G/Xv3pzGXdMUl9xNc2Nk7wUOAh+lq3K1LrXs=";
    stripRoot = false;
=======
    url = "https://github.com/bBoxType/FiraGo/archive/9882ba0851f88ab904dc237f250db1d45641f45d.zip";
    hash = "sha256-WwgPg7OLrXBjR6oHG5061RO3HeNkj2Izs6ktwIxVw9o=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  installPhase = ''
    runHook preInstall

<<<<<<< HEAD
    install --mode=644 -Dt $out/share/fonts/opentype Download_Folder_FiraGO*/Fonts/FiraGO_OTF*/*/*.otf
=======
    mkdir -p $out/share/fonts/opentype
    mv Fonts/FiraGO_OTF_1001/{Roman,Italic}/*.otf \
      $out/share/fonts/opentype
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

    runHook postInstall
  '';

<<<<<<< HEAD
  meta = {
    homepage = "https://carrois.com/fira/";
=======
  meta = with lib; {
    homepage = "https://bboxtype.com/typefaces/FiraGO";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    description = ''
      Font with the same glyph set as Fira Sans 4.3 and additionally
      supports Arabic, Devenagari, Georgian, Hebrew and Thai
    '';
<<<<<<< HEAD
    license = lib.licenses.ofl;
    maintainers = [ lib.maintainers.loicreynier ];
    platforms = lib.platforms.all;
=======
    license = licenses.ofl;
    maintainers = [ maintainers.loicreynier ];
    platforms = platforms.all;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}

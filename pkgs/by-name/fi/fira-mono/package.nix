{
  lib,
  stdenvNoCC,
  fetchzip,
}:

stdenvNoCC.mkDerivation rec {
  pname = "fira-mono";
  version = "3.2";

  src = fetchzip {
<<<<<<< HEAD
    url = "https://carrois.com/downloads/Fira/Fira_Mono_${
=======
    url = "https://bboxtype.com/downloads/Fira/Fira_Mono_${
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      lib.replaceStrings [ "." ] [ "_" ] version
    }.zip";
    hash = "sha256-Ukc+K2sdSz+vUQFD8mmwJHZQ3N68oM4fk6YzGLwzAfQ=";
  };

  installPhase = ''
    runHook preInstall

    install -Dm644 Fonts/FiraMono_OTF*/*.otf -t $out/share/fonts/opentype

    runHook postInstall
  '';

<<<<<<< HEAD
  meta = {
    homepage = "https://carrois.com/fira/";
=======
  meta = with lib; {
    homepage = "https://bboxtype.com/fira/";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    description = "Monospace font for Firefox OS";
    longDescription = ''
      Fira Mono is a monospace font designed by Erik Spiekermann,
      Ralph du Carrois, Anja Meiners and Botio Nikoltchev of Carrois
      Type Design for Mozilla Firefox OS. Available in Regular,
      Medium, and Bold.
    '';
<<<<<<< HEAD
    license = lib.licenses.ofl;
    maintainers = [ lib.maintainers.rycee ];
    platforms = lib.platforms.all;
=======
    license = licenses.ofl;
    maintainers = [ maintainers.rycee ];
    platforms = platforms.all;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}

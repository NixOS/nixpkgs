{
  lib,
<<<<<<< HEAD
  stdenvNoCC,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation {
=======
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pname = "inconsolata";
  version = "3.001";

  src = fetchFromGitHub {
    owner = "google";
    repo = "fonts";
    rev = "0f203e3740b5eb77e0b179dff1e5869482676782";
<<<<<<< HEAD
    hash = "sha256-4+aIjVO9/L4mCWGYqL1drFehHZTjRL25vTwh3c7GoFk=";
    rootDir = "ofl/inconsolata";
  };

  installPhase = ''
    runHook preInstall
    install -m644 --target $out/share/fonts/truetype/inconsolata -D static/*.ttf *.ttf
    runHook postInstall
  '';

  meta = {
    homepage = "https://www.levien.com/type/myfonts/inconsolata.html";
    description = "Monospace font for both screen and print";
    maintainers = with lib.maintainers; [
=======
    sha256 = "sha256-Q8eUJ0mkoB245Ifz5ulxx61x4+AqKhG0uqhWF2nSLpw=";
  };

  installPhase = ''
    install -m644 --target $out/share/fonts/truetype/inconsolata -D $src/ofl/inconsolata/static/*.ttf $src/ofl/inconsolata/*.ttf
  '';

  meta = with lib; {
    homepage = "https://www.levien.com/type/myfonts/inconsolata.html";
    description = "Monospace font for both screen and print";
    maintainers = with maintainers; [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      appsforartists
      mikoim
      raskin
    ];
<<<<<<< HEAD
    license = lib.licenses.ofl;
    platforms = lib.platforms.all;
=======
    license = licenses.ofl;
    platforms = platforms.all;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}

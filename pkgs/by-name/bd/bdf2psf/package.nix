{
  lib,
  stdenv,
  fetchurl,
  perl,
  dpkg,
}:

stdenv.mkDerivation rec {
  pname = "bdf2psf";
<<<<<<< HEAD
  version = "1.244";

  src = fetchurl {
    url = "mirror://debian/pool/main/c/console-setup/bdf2psf_${version}_all.deb";
    sha256 = "sha256-5qCqYh6s5ThjNu0YGwwCHQAK1hhpmPybLjcZAMOtkps=";
=======
  version = "1.240";

  src = fetchurl {
    url = "mirror://debian/pool/main/c/console-setup/bdf2psf_${version}_all.deb";
    sha256 = "sha256-TFCTCoWyEUzFQTSObk5SavBH1bTHQaGc5E/z6mtY5yU=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  nativeBuildInputs = [ dpkg ];

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall
    substituteInPlace usr/bin/bdf2psf --replace /usr/bin/perl "${perl}/bin/perl"
    rm usr/share/doc/bdf2psf/changelog.gz
    mv usr "$out"
    runHook postInstall
  '';

<<<<<<< HEAD
  meta = {
=======
  meta = with lib; {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    description = "BDF to PSF converter";
    homepage = "https://packages.debian.org/sid/bdf2psf";
    longDescription = ''
      Font converter to generate console fonts from BDF source fonts
    '';
<<<<<<< HEAD
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ rnhmjoj ];
    platforms = lib.platforms.all;
=======
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ rnhmjoj ];
    platforms = platforms.all;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "bdf2psf";
  };
}

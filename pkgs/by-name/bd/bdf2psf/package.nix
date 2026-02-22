{
  lib,
  stdenv,
  fetchurl,
  perl,
  dpkg,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "bdf2psf";
  version = "1.245";

  src = fetchurl {
    url = "mirror://debian/pool/main/c/console-setup/bdf2psf_${finalAttrs.version}_all.deb";
    sha256 = "sha256-2NG/UYz4e6nqkf0JvKQXXvy+mU2pMjaB3xyfI+Is/eY=";
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

  meta = {
    description = "BDF to PSF converter";
    homepage = "https://packages.debian.org/sid/bdf2psf";
    longDescription = ''
      Font converter to generate console fonts from BDF source fonts
    '';
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ rnhmjoj ];
    platforms = lib.platforms.all;
    mainProgram = "bdf2psf";
  };
})

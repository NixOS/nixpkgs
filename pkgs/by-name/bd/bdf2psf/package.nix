{ lib, stdenv, fetchurl, perl, dpkg }:

stdenv.mkDerivation rec {
  pname = "bdf2psf";
  version = "1.232";

  src = fetchurl {
    url = "mirror://debian/pool/main/c/console-setup/bdf2psf_${version}_all.deb";
    sha256 = "sha256-+C3t/W/mXJacF0d5Yk325TpZm8A3Qhno0ZyJUGjhU8U=";
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

  meta = with lib; {
    description = "BDF to PSF converter";
    homepage = "https://packages.debian.org/sid/bdf2psf";
    longDescription = ''
      Font converter to generate console fonts from BDF source fonts
    '';
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ rnhmjoj  ];
    platforms = platforms.all;
    mainProgram = "bdf2psf";
  };
}

{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lsscsi";
  version = "0.32";

  src = fetchurl {
    url = "http://sg.danny.cz/scsi/lsscsi-${finalAttrs.version}.tgz";
    sha256 = "sha256-CoAOnpTcoqtwLWXXJ3eujK4Hjj100Ly+1kughJ6AKaE=";
  };

  preConfigure = ''
    substituteInPlace Makefile.in --replace /usr "$out"
  '';

  meta = {
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
})

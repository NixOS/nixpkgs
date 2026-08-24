{
  lib,
  stdenv,
  fetchurl,
}:
stdenv.mkDerivation (finalAttrs: {
  version = "5.3.2";
  src = fetchurl {
    url = "mirror://gnu/osip/libosip2-${finalAttrs.version}.tar.gz";
    sha256 = "sha256-Fhhvb1VAk2tiw6rKboQJ4a8lzSKrw4grOTviFfSdOwA=";
  };
  pname = "libosip2";

  meta = {
    license = lib.licenses.lgpl21Plus;
    homepage = "https://www.gnu.org/software/osip/";
    description = "GNU oSIP library, an implementation of the Session Initiation Protocol (SIP)";
    maintainers = with lib.maintainers; [ raskin ];
    platforms = lib.platforms.all;
  };
})

{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  glib,
  dbus-glib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libaudclient";
  version = "3.5-rc2";

  src = fetchurl {
    url = "https://distfiles.audacious-media-player.org/libaudclient-${finalAttrs.version}.tar.bz2";
    sha256 = "0nhpgz0kg8r00z54q5i96pjk7s57krq3fvdypq496c7fmlv9kdap";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    glib
    dbus-glib
  ];

  meta = {
    description = "Legacy D-Bus client library for Audacious";
    homepage = "https://audacious-media-player.org/";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ pSub ];
    platforms = with lib.platforms; unix;
  };
})

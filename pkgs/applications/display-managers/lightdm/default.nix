{ stdenv, fetchurl, pam, pkgconfig, libxcb, glib, libXdmcp, itstool, libxml2, intltool, x11, libxklavier, libgcrypt, makeWrapper }:

stdenv.mkDerivation {
  name = "lightdm-1.5.1";

  src = fetchurl {
    url = https://launchpad.net/lightdm/1.6/1.5.1/+download/lightdm-1.5.1.tar.xz;
    sha256 = "645db2d763cc514d6aecb1838f4a9c33c3dcf0c94567a7ef36c6b23d8aa56c86";
  };

  buildInputs = [ pkgconfig pam libxcb glib libXdmcp itstool libxml2 intltool libxklavier libgcrypt makeWrapper ];

  configureFlags = [ "--enable-liblightdm-gobject" ];

  patches =
    [ ./lightdm.patch
    ];

  patchFlags = "-p0";

  meta = {
    homepage = http://launchpad.net/lightdm;
    platforms = stdenv.lib.platforms.linux;
  };
}
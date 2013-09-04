{ stdenv, fetchurl, pkgconfig, lib, openssl, glib, libX11, gtk3, gettext, intltool }:

stdenv.mkDerivation rec {
  name = "fribid-1.0.2";
  builder = ./builder.sh;

  src = fetchurl {
    url = https://fribid.se/releases/source/fribid-1.0.2.tar.bz2;
    sha256 = "d7cd9adf04fedf50b266a5c14ddb427cbb263d3bc160ee0ade03aca9d5356e5c";
  };

  buildInputs = [ pkgconfig openssl libX11 gtk3 glib gettext intltool ];

  configureFlags = "--plugin-path=/lib/mozilla/plugins";

  passthru.mozillaPlugin = "/lib/mozilla/plugins";

  meta = {
    description = "A browser plugin to manage Swedish BankID:s";
    homepage = http://fribid.se;
    licenses = [ "GPLv2" "MPLv1" ];
    maintainers = [ lib.maintainers.edwtjo ];
    platforms = with stdenv.lib.platforms; linux;
  };
}


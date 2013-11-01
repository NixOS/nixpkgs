{ stdenv, fetchurl, pkgconfig, openssl, glib, libX11, gtk3, gettext, intltool }:

let version = "1.0.2"; in
stdenv.mkDerivation rec {
  name = "fribid-${version}";
  builder = ./builder.sh;

  src = fetchurl {
    url = "https://fribid.se/releases/source/${name}.tar.bz2";
    sha256 = "d7cd9adf04fedf50b266a5c14ddb427cbb263d3bc160ee0ade03aca9d5356e5c";
  };

  buildInputs = [ pkgconfig openssl libX11 gtk3 glib gettext intltool ];
  patches = [
    ./translation-xgettext-to-intltool.patch
    ./plugin-linkfix.patch
    ./emulated-version.patch
    ./ipc-lazytrace.patch
    ];

  passthru.mozillaPlugin = "/lib/mozilla/plugins";

  meta = {
    description = "A browser plugin to manage Swedish BankID:s";
    homepage = http://fribid.se;
    licenses = [ "GPLv2" "MPLv1" ];
    maintainers = [ stdenv.lib.maintainers.edwtjo ];
    platforms = with stdenv.lib.platforms; linux;
  };
}


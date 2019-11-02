{ stdenv, fetchurl, pkgconfig, openssl, glib, libX11, gtk2, gettext, intltool }:

stdenv.mkDerivation rec {
  pname = "fribid";
  version = "1.0.4";
  builder = ./builder.sh;

  src = fetchurl {
    url = "https://fribid.se/releases/source/${pname}-${version}.tar.bz2";
    sha256 = "a679f3a0534d5f05fac10b16b49630a898c0b721cfa24d2c827fa45485476649";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ openssl libX11 gtk2 glib gettext intltool ];
  patches = [
    ./translation-xgettext-to-intltool.patch
    ./plugin-linkfix.patch
    ./ipc-lazytrace.patch
    ];

  postPatch = "substituteInPlace plugin/pluginutil.c --replace strndup strndup_";

  passthru.mozillaPlugin = "/lib/mozilla/plugins";

  meta = with stdenv.lib; {
    description = "A browser plugin to manage Swedish BankID:s";
    longDescription = ''
      FriBID is an open source software for the Swedish e-id system
      called BankID. FriBID also supports processor architectures and
      Linux/BSD distributions that the official software doesn't
      support.
    '';
    homepage = http://fribid.se;
    license = with licenses; [ gpl2 mpl10 ];
    maintainers = [ maintainers.edwtjo ];
    platforms = platforms.linux;
  };
}

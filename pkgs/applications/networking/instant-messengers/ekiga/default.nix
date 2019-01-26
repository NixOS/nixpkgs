{ stdenv, glib, fetchurl, fetchpatch, cyrus_sasl, gettext, openldap, ptlib, opal, libXv, rarian, intltool
, perlPackages, evolution-data-server, gnome-doc-utils, avahi, autoreconfHook
, libsigcxx, gtk, dbus-glib, libnotify, libXext, xorgproto, gnome3, boost, libsecret
, pkgconfig, libxml2, unixODBC, db, nspr, nss, zlib
, libXrandr, which, libxslt, libtasn1, gmp, nettle, sqlite, makeWrapper }:

stdenv.mkDerivation rec {
  name = "ekiga-4.0.1";

  src = fetchurl {
    url = "mirror://gnome/sources/ekiga/4.0/${name}.tar.xz";
    sha256 = "5f4f491c9496cf65ba057a9345d6bb0278f4eca07bcda5baeecf50bfcd9a4a3b";
  };

  buildInputs = [ cyrus_sasl gettext openldap ptlib opal libXv rarian intltool
                  evolution-data-server gnome-doc-utils avahi
                  libsigcxx gtk dbus-glib libnotify libXext xorgproto sqlite
                  gnome3.libsoup glib gnome3.defaultIconTheme boost
                  autoreconfHook pkgconfig libxml2 unixODBC db nspr
                  nss zlib libsecret libXrandr which libxslt libtasn1
                  gmp nettle makeWrapper ]
    ++ (with perlPackages; [ perl XMLParser ]);

  preAutoreconf = ''
    substituteInPlace configure.ac --replace AM_GCONF_SOURCE_2 ""
    substituteInPlace configure.ac --replace gnome-icon-theme adwaita-icon-theme
  '';

  configureFlags = [
    "--with-ldap-dir=${openldap.dev}"
    "--with-libsasl2-dir=${cyrus_sasl.dev}"
    "--with-boost-libdir=${boost.out}/lib"
    "--disable-gconf"
  ];

  enableParallelBuilding = true;

  patches = [
    (fetchpatch { url = https://sources.debian.net/data/main/e/ekiga/4.0.1-7/debian/patches/autofoo.patch;
      sha256 = "1vyagslws4mm9yfz1m5p1kv9sxmk5lls9vxpm6j72q2ahsgydzx4";
    })
    (fetchpatch { url = https://sources.debian.net/data/main/e/ekiga/4.0.1-7/debian/patches/boost.patch;
      sha256 = "01k0rw8ibrrf9zn9lx6dzbrgy58w089hqxqxqdv9whb65cldlj5s";
    })
    (fetchpatch { url = https://src.fedoraproject.org/rpms/ekiga/raw/dbf5f5ba449d22bd79f0394cddb7d4d8a88ec6ac/f/ekiga-4.0.1-libresolv.patch;
      sha256 = "18wc68im8422ibpa0gkrkgjq41m7hikaha3xqmjs2km45i1cwcaz";
    })
  ];

  postInstall = ''
    wrapProgram "$out"/bin/ekiga \
      --prefix XDG_DATA_DIRS : "$XDG_ICON_DIRS:$GSETTINGS_SCHEMAS_PATH"
  '';

  meta = with stdenv.lib; {
    description = "VOIP/Videoconferencing app with full SIP and H.323 support";
    maintainers = [ maintainers.raskin ];
    platforms = platforms.linux;
    license = licenses.gpl2Plus;
  };

  passthru = {
    updateInfo = {
      downloadPage = "mirror://gnome/sources/ekiga";
    };
  };
}


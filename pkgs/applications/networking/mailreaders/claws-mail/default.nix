{ fetchurl, stdenv, wrapGAppsHook
, curl, dbus, dbus_glib, enchant, gtk2, gnutls, gnupg, gpgme, hicolor_icon_theme
, libarchive, libcanberra_gtk2, libetpan, libnotify, libsoup, libxml2, networkmanager
, openldap , perl, pkgconfig, poppler, python, shared_mime_info, webkitgtk24x-gtk2
, glib_networking, gsettings_desktop_schemas, libSM, libytnef

# Build options
# TODO: A flag to build the manual.
# TODO: Plugins that complain about their missing dependencies, even when
#       provided:
#         gdata requires libgdata
#         geolocation requires libchamplain
#         python requires python
, enableLdap ? false
, enableNetworkManager ? false
, enablePgp ? true
, enablePluginArchive ? false
, enablePluginFancy ? false
, enablePluginNotificationDialogs ? true
, enablePluginNotificationSounds ? true
, enablePluginPdf ? false
, enablePluginRavatar ? false
, enablePluginRssyl ? false
, enablePluginSmime ? false
, enablePluginSpamassassin ? false
, enablePluginSpamReport ? false
, enablePluginVcalendar ? false
, enableSpellcheck ? false
}:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "claws-mail-${version}";
  version = "3.15.0";

  src = fetchurl {
    url = "http://www.claws-mail.org/download.php?file=releases/claws-mail-${version}.tar.xz";
    sha256 = "0bnwd3l04y6j1nw3h861rdy6k6lyjzsi51j04d33vbpq8c6jskaf";
  };

  patches = [ ./mime.patch ];

  hardeningDisable = [ "format" ];

  postPatch = ''
    substituteInPlace src/procmime.c \
        --subst-var-by MIMEROOTDIR ${shared_mime_info}/share
  '';

  nativeBuildInputs = [ pkgconfig wrapGAppsHook ];

  buildInputs =
    [ curl dbus dbus_glib gtk2 gnutls gsettings_desktop_schemas hicolor_icon_theme
      libetpan perl python glib_networking libSM libytnef
    ]
    ++ optional enableSpellcheck enchant
    ++ optionals (enablePgp || enablePluginSmime) [ gnupg gpgme ]
    ++ optional enablePluginArchive libarchive
    ++ optional enablePluginNotificationSounds libcanberra_gtk2
    ++ optional enablePluginNotificationDialogs libnotify
    ++ optional enablePluginFancy libsoup
    ++ optional enablePluginRssyl libxml2
    ++ optional enableNetworkManager networkmanager
    ++ optional enableLdap openldap
    ++ optional enablePluginPdf poppler
    ++ optional enablePluginFancy webkitgtk24x-gtk2;

  configureFlags =
    optional (!enableLdap) "--disable-ldap"
    ++ optional (!enableNetworkManager) "--disable-networkmanager"
    ++ optionals (!enablePgp) [
      "--disable-pgpcore-plugin"
      "--disable-pgpinline-plugin"
      "--disable-pgpmime-plugin"
    ]
    ++ optional (!enablePluginArchive) "--disable-archive-plugin"
    ++ optional (!enablePluginFancy) "--disable-fancy-plugin"
    ++ optional (!enablePluginPdf) "--disable-pdf_viewer-plugin"
    ++ optional (!enablePluginRavatar) "--disable-libravatar-plugin"
    ++ optional (!enablePluginRssyl) "--disable-rssyl-plugin"
    ++ optional (!enablePluginSmime) "--disable-smime-plugin"
    ++ optional (!enablePluginSpamassassin) "--disable-spamassassin-plugin"
    ++ optional (!enablePluginSpamReport) "--disable-spam_report-plugin"
    ++ optional (!enablePluginVcalendar) "--disable-vcalendar-plugin"
    ++ optional (!enableSpellcheck) "--disable-enchant";

  enableParallelBuilding = true;

  preFixup = ''
    gappsWrapperArgs+=(--prefix XDG_DATA_DIRS : "${shared_mime_info}/share")
  '';

  postInstall = ''
    mkdir -p $out/share/applications
    cp claws-mail.desktop $out/share/applications
  '';

  meta = {
    description = "The user-friendly, lightweight, and fast email client";
    homepage = http://www.claws-mail.org/;
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ khumba fpletz globin ];
  };
}

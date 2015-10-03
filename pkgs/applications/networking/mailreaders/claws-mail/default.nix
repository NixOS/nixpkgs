{ fetchurl, stdenv
, curl, dbus, dbus_glib, enchant, gtk, gnutls, gnupg, gpgme, hicolor_icon_theme
, libarchive, libcanberra, libetpan, libnotify, libsoup, libxml2, networkmanager
, openldap , perl, pkgconfig, poppler, python, shared_mime_info, webkitgtk2

# Build options
# TODO: A flag to build the manual.
# TODO: Plugins that complain about their missing dependencies, even when
#       provided:
#         gdata requires libgdata
#         geolocation requires libchamplain
#         python requires python
, enableLdap ? false
, enableNetworkManager ? false
, enablePgp ? false
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

let version = "3.11.1"; in

stdenv.mkDerivation {
  name = "claws-mail-${version}";

  meta = {
    description = "The user-friendly, lightweight, and fast email client";
    homepage = http://www.claws-mail.org/;
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = [ maintainers.khumba ];
    priority = 10;  # Resolve the conflict with the share/mime link we create.
  };

  src = fetchurl {
    url = "http://downloads.sourceforge.net/project/claws-mail/Claws%20Mail/${version}/claws-mail-${version}.tar.bz2";
    sha256 = "0w13xzri9d3165qsxf1dig1f0gxn3ib4lysfc9pgi4zpyzd0zgrw";
  };

  patches = [ ./mime.patch ];

  buildInputs =
    [ curl dbus dbus_glib gtk gnutls hicolor_icon_theme
      libetpan perl pkgconfig python
    ]
    ++ optional enableSpellcheck enchant
    ++ optionals (enablePgp || enablePluginSmime) [ gnupg gpgme ]
    ++ optional enablePluginArchive libarchive
    ++ optional enablePluginNotificationSounds libcanberra
    ++ optional enablePluginNotificationDialogs libnotify
    ++ optional enablePluginFancy libsoup
    ++ optional enablePluginRssyl libxml2
    ++ optional enableNetworkManager networkmanager
    ++ optional enableLdap openldap
    ++ optional enablePluginPdf poppler
    ++ optional enablePluginFancy webkitgtk2;

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

  postInstall = ''
    mkdir -p $out/share/applications
    cp claws-mail.desktop $out/share/applications

    ln -sT ${shared_mime_info}/share/mime $out/share/mime
  '';
}

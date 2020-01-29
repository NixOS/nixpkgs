{ config, fetchurl, stdenv, wrapGAppsHook, autoreconfHook
, curl, dbus, dbus-glib, enchant, gtk2, gnutls, gnupg, gpgme
, libarchive, libcanberra-gtk2, libetpan, libnotify, libsoup, libxml2, networkmanager
, openldap, perl, pkgconfig, poppler, python, shared-mime-info
, glib-networking, gsettings-desktop-schemas, libSM, libytnef, libical
# Build options
# TODO: A flag to build the manual.
# TODO: Plugins that complain about their missing dependencies, even when
#       provided:
#         gdata requires libgdata
#         geolocation requires libchamplain
, enableLdap ? false
, enableNetworkManager ? config.networking.networkmanager.enable or false
, enablePgp ? true
, enablePluginArchive ? false
, enablePluginNotificationDialogs ? true
, enablePluginNotificationSounds ? true
, enablePluginPdf ? false
, enablePluginPython ? false
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
  pname = "claws-mail";
  version = "3.17.4";

  src = fetchurl {
    url = "http://www.claws-mail.org/download.php?file=releases/claws-mail-${version}.tar.xz";
    sha256 = "00mfhaac16sv67rwiq98hr4nl5zmd1h2afswwwksdcsi3q9x23jr";
  };

  outputs = [ "out" "dev" ];

  patches = [ ./mime.patch ];

  preConfigure = ''
    # autotools check tries to dlopen libpython as a requirement for the python plugin
    export LD_LIBRARY_PATH=$LD_LIBRARY_PATH''${LD_LIBRARY_PATH:+:}${python}/lib
  '';

  postPatch = ''
    substituteInPlace src/procmime.c \
        --subst-var-by MIMEROOTDIR ${shared-mime-info}/share
  '';

  nativeBuildInputs = [ autoreconfHook pkgconfig wrapGAppsHook python.pkgs.wrapPython ];
  propagatedBuildInputs = with python.pkgs; [ python ] ++ optionals enablePluginPython [ pygtk pygobject2 ];

  buildInputs =
    [ curl dbus dbus-glib gtk2 gnutls gsettings-desktop-schemas
      libetpan perl glib-networking libSM libytnef
    ]
    ++ optional enableSpellcheck enchant
    ++ optionals (enablePgp || enablePluginSmime) [ gnupg gpgme ]
    ++ optional enablePluginArchive libarchive
    ++ optional enablePluginNotificationSounds libcanberra-gtk2
    ++ optional enablePluginNotificationDialogs libnotify
    ++ optional enablePluginRssyl libxml2
    ++ optional enableNetworkManager networkmanager
    ++ optional enableLdap openldap
    ++ optional enablePluginPdf poppler
    ++ optional enablePluginVcalendar libical;

  configureFlags =
    optional (!enableLdap) "--disable-ldap"
    ++ optional (!enableNetworkManager) "--disable-networkmanager"
    ++ optionals (!enablePgp) [
      "--disable-pgpcore-plugin"
      "--disable-pgpinline-plugin"
      "--disable-pgpmime-plugin"
    ]
    ++ optional (!enablePluginArchive) "--disable-archive-plugin"
    ++ optional (!enablePluginPdf) "--disable-pdf_viewer-plugin"
    ++ optional (!enablePluginPython) "--disable-python-plugin"
    ++ optional (!enablePluginRavatar) "--disable-libravatar-plugin"
    ++ optional (!enablePluginRssyl) "--disable-rssyl-plugin"
    ++ optional (!enablePluginSmime) "--disable-smime-plugin"
    ++ optional (!enablePluginSpamassassin) "--disable-spamassassin-plugin"
    ++ optional (!enablePluginSpamReport) "--disable-spam_report-plugin"
    ++ optional (!enablePluginVcalendar) "--disable-vcalendar-plugin"
    ++ optional (!enableSpellcheck) "--disable-enchant";

  enableParallelBuilding = true;

  pythonPath = with python.pkgs; [ pygobject2 pygtk ];

  preFixup = ''
    buildPythonPath "$out $pythonPath"
    gappsWrapperArgs+=(--prefix XDG_DATA_DIRS : "${shared-mime-info}/share" --prefix PYTHONPATH : "$program_PYTHONPATH")
  '';

  postInstall = ''
    mkdir -p $out/share/applications
    cp claws-mail.desktop $out/share/applications
  '';

  meta = {
    description = "The user-friendly, lightweight, and fast email client";
    homepage = https://www.claws-mail.org/;
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ fpletz globin ];
  };
}

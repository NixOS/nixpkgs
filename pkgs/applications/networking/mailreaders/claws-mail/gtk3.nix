{ config, fetchgit, stdenv, wrapGAppsHook, autoreconfHook, bison, flex
, curl, dbus, dbus-glib, enchant, gtk3, gnutls, gnupg, gpgme
, libarchive, libcanberra-gtk3, libetpan, libnotify, libsoup, libxml2, networkmanager
, openldap, perl, pkgconfig, poppler, python, shared-mime-info, webkitgtk
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
, enablePluginFancy ? true
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
  pname = "claws-mail-gtk3";
  version = "3.17.5";

  src = fetchgit {
    url = "git://git.claws-mail.org/claws.git";
    rev = "c1e1902323c2b5dfe82144328b7933dc857ef343"; # this commit is "for release 3.17.5"
    sha256 = "0cqzlzcms6alvsdsbcc06bsdi1h349b16qngn2z1p8fz16x6s6cy";
  };

  outputs = [ "out" "dev" ];

  patches = [ ./mime.patch ];

  preConfigure = ''
    # autotools check tries to dlopen libpython as a requirement for the python plugin
    export LD_LIBRARY_PATH=$LD_LIBRARY_PATH''${LD_LIBRARY_PATH:+:}${python}/lib
    # generate version without .git
    [ -e version ] || echo "echo ${version}" > version
  '';

  postPatch = ''
    substituteInPlace src/procmime.c \
        --subst-var-by MIMEROOTDIR ${shared-mime-info}/share
  '';

  nativeBuildInputs = [ autoreconfHook bison flex pkgconfig wrapGAppsHook python.pkgs.wrapPython ];
  propagatedBuildInputs = with python.pkgs; [ python ] ++ optionals enablePluginPython [ pygtk pygobject2 ];

  buildInputs =
    [ curl dbus dbus-glib gtk3 gnutls gsettings-desktop-schemas
      libetpan perl glib-networking libSM libytnef
    ]
    ++ optional enableSpellcheck enchant
    ++ optionals (enablePgp || enablePluginSmime) [ gnupg gpgme ]
    ++ optional enablePluginArchive libarchive
    ++ optional enablePluginNotificationSounds libcanberra-gtk3
    ++ optional enablePluginNotificationDialogs libnotify
    ++ optional enablePluginFancy libsoup
    ++ optional enablePluginRssyl libxml2
    ++ optional enableNetworkManager networkmanager
    ++ optional enableLdap openldap
    ++ optional enablePluginPdf poppler
    ++ optional enablePluginFancy webkitgtk
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
    ++ optional (!enablePluginFancy) "--disable-fancy-plugin"
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

  NIX_CFLAGS_COMPILE = [ "-Wno-deprecated-declarations" ];

  meta = {
    description = "The user-friendly, lightweight, and fast email client";
    homepage = "https://www.claws-mail.org/";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ fpletz globin orivej ];
  };
}

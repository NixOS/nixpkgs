{ stdenv, lib, fetchgit, wrapGAppsHook, autoreconfHook, bison, flex
, curl, gtk2, gtk3, pkg-config, python2, python3, shared-mime-info
, glib-networking, gsettings-desktop-schemas

# Use the experimental gtk3 branch.
, useGtk3 ? false

# Package compatibility: old parameters whose name were not directly derived
, enablePgp ? true
, enablePluginNotificationDialogs ? true
, enablePluginNotificationSounds ? true
, enablePluginPdf ? true
, enablePluginRavatar ? true
, enableSpellcheck ? true

# Arguments to include external libraries
, enableLibSM ? true, libSM
, enableGnuTLS ? true, gnutls
, enableEnchant ? enableSpellcheck, enchant
, enableDbus ? true, dbus, dbus-glib
, enableLdap ? true, openldap
, enableNetworkManager ? true, networkmanager
, enableLibetpan ? true, libetpan
, enableValgrind ? true, valgrind
, enableSvg ? true, librsvg

# Configure claws-mail's plugins
, enablePluginAcpiNotifier ? true
, enablePluginAddressKeeper ? true
, enablePluginArchive ? true, libarchive
, enablePluginAttRemover ? true
, enablePluginAttachWarner ? true
, enablePluginBogofilter ? true
, enablePluginBsfilter ? true
, enablePluginClamd ? true
, enablePluginDillo ? true
, enablePluginFetchInfo ? true
, enablePluginLibravatar ? enablePluginRavatar
, enablePluginLitehtmlViewer ? true, gumbo
, enablePluginMailmbox ? true
, enablePluginManageSieve ? true
, enablePluginNewMail ? true
, enablePluginNotification ? (enablePluginNotificationDialogs || enablePluginNotificationSounds), libcanberra-gtk2, libcanberra-gtk3, libnotify
, enablePluginPdfViewer ? enablePluginPdf, poppler
, enablePluginPerl ? true, perl
, enablePluginPython ? true
, enablePluginPgp ? enablePgp, gnupg, gpgme
, enablePluginRssyl ? true, libxml2
, enablePluginSmime ? true
, enablePluginSpamassassin ? true
, enablePluginSpamReport ? true
, enablePluginTnefParse ? true, libytnef
, enablePluginVcalendar ? true, libical
}:

with lib;

let
  version = "3.17.8";

  # The official release uses gtk2 and contains the version tag.
  gtk2src = {
    rev = version;
    sha256 = "0l4f8q11iyj8pi120lrapgq51k5j64xf0jlczkzbm99rym752ch5";
  };

  # The corresponding commit in the gtk3 branch.
  gtk3src = {
    rev = "3.99.0";
    sha256 = "176h1swh1zx6dqyzfz470x4a1xicnv0zhy8ir47k7p23g6y17i2k";
  };

  python = if useGtk3 then python3 else python2;
  pythonPkgs = if useGtk3
    then
      with python.pkgs; [ python wrapPython pygobject3 ]
    else
      with python.pkgs; [ python wrapPython pygtk pygobject2 ];
in stdenv.mkDerivation rec {
  pname = "claws-mail";
  inherit version;

  src = fetchgit ({
    url = "git://git.claws-mail.org/claws.git";
  } // (if useGtk3 then gtk3src else gtk2src));

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

  nativeBuildInputs = [ autoreconfHook pkg-config bison flex wrapGAppsHook ];
  propagatedBuildInputs = pythonPkgs;

  buildInputs =
    [ curl gsettings-desktop-schemas glib-networking ]
    ++ [(if useGtk3 then gtk3 else gtk2)]
    ++ optional  enableLibSM libSM
    ++ optional  enableGnuTLS gnutls
    ++ optional  enableEnchant enchant
    ++ optionals enableDbus [ dbus dbus-glib ]
    ++ optional  enableLdap openldap
    ++ optional  enableNetworkManager networkmanager
    ++ optional  enableLibetpan libetpan
    ++ optional  enableValgrind valgrind
    ++ optional  enableSvg librsvg
    ++ optional  enablePluginArchive libarchive
    ++ optional  enablePluginLitehtmlViewer gumbo
    ++ optionals enablePluginNotification [ libnotify ] ++ [(if useGtk3 then libcanberra-gtk3 else libcanberra-gtk2)]
    ++ optional  enablePluginPerl perl
    ++ optional  enablePluginPdfViewer poppler
    ++ optional  enablePluginRssyl libxml2
    ++ optionals enablePluginPgp [ gnupg gpgme ]
    ++ optional  enablePluginTnefParse libytnef
    ++ optional  enablePluginVcalendar libical
  ;

  configureFlags =
    [
      "--disable-manual"   # Missing docbook-tools, e.g., docbook2html
      "--disable-compface" # Missing compface library
      "--disable-jpilot"   # Missing jpilot library

      "--disable-gdata-plugin" # Complains about missing libgdata, even when provided
      "--disable-fancy-plugin" # Missing libwebkit-1.0 library
    ]
    ++
    (map (e: strings.enableFeature (lists.head e) (lists.last e)) [
      [ enableLibSM "libsm" ]
      [ enableGnuTLS "gnutls" ]
      [ enableEnchant "enchant" ]
      [ enableDbus "dbus" ]
      [ enableLdap "ldap" ]
      [ enableNetworkManager "networkmanager" ]
      [ enableLibetpan "libetpan" ]
      [ enableValgrind "valgrind" ]
      [ enableSvg "svg" ]

      [ enablePluginAcpiNotifier "acpi_notifier-plugin" ]
      [ enablePluginAddressKeeper "address_keeper-plugin" ]
      [ enablePluginArchive "archive-plugin" ]
      [ enablePluginAttRemover "att_remover-plugin" ]
      [ enablePluginAttachWarner "attachwarner-plugin" ]
      [ enablePluginBogofilter "bogofilter-plugin" ]
      [ enablePluginBsfilter "bsfilter-plugin" ]
      [ enablePluginClamd "clamd-plugin" ]
      [ enablePluginDillo "dillo-plugin" ]
      [ enablePluginFetchInfo "fetchinfo-plugin" ]
      [ enablePluginLibravatar "libravatar-plugin" ]
      [ enablePluginLitehtmlViewer "litehtml_viewer-plugin" ]
      [ enablePluginMailmbox "mailmbox-plugin" ]
      [ enablePluginManageSieve "managesieve-plugin" ]
      [ enablePluginNewMail "newmail-plugin" ]
      [ enablePluginNotification "notification-plugin" ]
      [ enablePluginPdfViewer "pdf_viewer-plugin" ]
      [ enablePluginPerl "perl-plugin" ]
      [ enablePluginPython "python-plugin" ]
      [ enablePluginPgp "pgpcore-plugin" ]
      [ enablePluginPgp "pgpmime-plugin" ]
      [ enablePluginPgp "pgpinline-plugin" ]
      [ enablePluginRssyl "rssyl-plugin" ]
      [ enablePluginSmime "smime-plugin" ]
      [ enablePluginSpamassassin "spamassassin-plugin" ]
      [ enablePluginSpamReport "spam_report-plugin" ]
      [ enablePluginTnefParse "tnef_parse-plugin" ]
      [ enablePluginVcalendar "vcalendar-plugin" ]
    ]);

  enableParallelBuilding = true;

  preFixup = ''
    buildPythonPath "$out $pythonPkgs"
    gappsWrapperArgs+=(--prefix XDG_DATA_DIRS : "${shared-mime-info}/share" --prefix PYTHONPATH : "$program_PYTHONPATH")
  '';

  postInstall = ''
    mkdir -p $out/share/applications
    cp claws-mail.desktop $out/share/applications
  '';

  meta = {
    description = "The user-friendly, lightweight, and fast email client";
    homepage = "https://www.claws-mail.org/";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ fpletz globin orivej oxzi ];
  };
}

{ stdenv, lib, fetchgit, fetchpatch, wrapGAppsHook, autoreconfHook, bison, flex
, curl, gtk2, gtk3, pkg-config, python2, python3, shared-mime-info
, glib-networking, gsettings-desktop-schemas

# Selector between the GTK+ 3 and GTK+ 2 releases.
, useGtk3

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
, enableValgrind ? !stdenv.isDarwin && lib.meta.availableOn stdenv.hostPlatform valgrind, valgrind
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
, enablePluginFancy ? useGtk3, libsoup, webkitgtk
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
  # Last release and hash for both the GTK+ 3 and GTK+ 2 version.
  version = if useGtk3 then "4.0.0" else "3.18.0";

  gtk2src = {
    sha256 = "1vsiy3xsppw4d8ylsz70wsyrvmgy88lp2hj7vrc353ckny80r9lh";
  };

  gtk3src = {
    sha256 = "0mwnjiqg2sj61va0y9yi3v52iyr5kzmbnvsqxav3a48m2f8p27qn";
  };

  python = if useGtk3 then python3 else python2;
  pythonPkgs = if useGtk3
    then
      with python.pkgs; [ python wrapPython pygobject3 ]
    else
      with python.pkgs; [ python wrapPython pygtk pygobject2 ];

  features = [
    { flags = [ "acpi_notifier-plugin" ]; enabled = enablePluginAcpiNotifier; }
    { flags = [ "address_keeper-plugin" ]; enabled = enablePluginAddressKeeper; }
    { flags = [ "archive-plugin" ]; enabled = enablePluginArchive; deps = [ libarchive ]; }
    { flags = [ "att_remover-plugin" ]; enabled = enablePluginAttRemover; }
    { flags = [ "attachwarner-plugin" ]; enabled = enablePluginAttachWarner; }
    { flags = [ "bogofilter-plugin" ]; enabled = enablePluginBogofilter; }
    { flags = [ "bsfilter-plugin" ]; enabled = enablePluginBsfilter; }
    { flags = [ "clamd-plugin" ]; enabled = enablePluginClamd; }
    { flags = [ "dbus" ]; enabled = enableDbus; deps = [ dbus dbus-glib ]; }
    { flags = [ "dillo-plugin" ]; enabled = enablePluginDillo; }
    { flags = [ "enchant" ]; enabled = enableEnchant; deps = [ enchant ]; }
    { flags = [ "fancy-plugin" ]; enabled = enablePluginFancy; deps = [ libsoup webkitgtk ]; }
    { flags = [ "fetchinfo-plugin" ]; enabled = enablePluginFetchInfo; }
    { flags = [ "gnutls" ]; enabled = enableGnuTLS; deps = [ gnutls ]; }
    { flags = [ "ldap" ]; enabled = enableLdap; deps = [ openldap ]; }
    { flags = [ "libetpan" ]; enabled = enableLibetpan; deps = [ libetpan ]; }
    { flags = [ "libravatar-plugin" ]; enabled = enablePluginLibravatar; }
    { flags = [ "libsm" ]; enabled = enableLibSM; deps = [ libSM ]; }
    { flags = [ "litehtml_viewer-plugin" ]; enabled = enablePluginLitehtmlViewer; deps = [ gumbo ]; }
    { flags = [ "mailmbox-plugin" ]; enabled = enablePluginMailmbox; }
    { flags = [ "managesieve-plugin" ]; enabled = enablePluginManageSieve; }
    { flags = [ "networkmanager" ]; enabled = enableNetworkManager; deps = [ networkmanager ]; }
    { flags = [ "newmail-plugin" ]; enabled = enablePluginNewMail; }
    { flags = [ "notification-plugin" ]; enabled = enablePluginNotification; deps = [ libnotify ] ++ [(if useGtk3 then libcanberra-gtk3 else libcanberra-gtk2)]; }
    { flags = [ "pdf_viewer-plugin" ]; enabled = enablePluginPdfViewer; deps = [ poppler ]; }
    { flags = [ "perl-plugin" ]; enabled = enablePluginPerl; deps = [ perl ]; }
    { flags = [ "pgpcore-plugin" "pgpinline-plugin" "pgpmime-plugin" ]; enabled = enablePluginPgp; deps = [ gnupg gpgme ]; }
    { flags = [ "python-plugin" ]; enabled = enablePluginPython; }
    { flags = [ "rssyl-plugin" ]; enabled = enablePluginRssyl; deps = [ libxml2 ]; }
    { flags = [ "smime-plugin" ]; enabled = enablePluginSmime; }
    { flags = [ "spam_report-plugin" ]; enabled = enablePluginSpamReport; }
    { flags = [ "spamassassin-plugin" ]; enabled = enablePluginSpamassassin; }
    { flags = [ "svg" ]; enabled = enableSvg; deps = [ librsvg ]; }
    { flags = [ "tnef_parse-plugin" ]; enabled = enablePluginTnefParse; deps = [ libytnef ]; }
    { flags = [ "valgrind" ]; enabled = enableValgrind; deps = [ valgrind ]; }
    { flags = [ "vcalendar-plugin" ]; enabled = enablePluginVcalendar; deps = [ libical ]; }
  ];
in stdenv.mkDerivation rec {
  pname = "claws-mail";
  inherit version;

  src = fetchgit ({
    rev = version;
    url = "git://git.claws-mail.org/claws.git";
  } // (if useGtk3 then gtk3src else gtk2src));

  outputs = [ "out" "dev" ];

  patches = [
    ./mime.patch

    # Fixes a bug with the automatic authentication method, resulting in errors
    # with certain mail providers.
    # <https://www.thewildbeast.co.uk/claws-mail/bugzilla/show_bug.cgi?id=4497>
    # This MUST be removed for the next release.
    (fetchpatch {
      name = "fix-automatic-auth.patch";
      url = "https://git.claws-mail.org/?p=claws.git;a=patch;h=9c2585c58b49815a0eab8d683f0a94f75cbbe64e";
      sha256 = "0v8v5q2p4h93lp7yq3gnlvarsrcssv96aks1wqy3187vsr4kdw7a";
    })
  ];

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
    ++ concatMap (f: optionals f.enabled f.deps) (filter (f: f ? deps) features)
  ;

  configureFlags =
    [
      "--disable-manual"   # Missing docbook-tools, e.g., docbook2html
      "--disable-compface" # Missing compface library
      "--disable-jpilot"   # Missing jpilot library

      "--disable-gdata-plugin" # Complains about missing libgdata, even when provided
    ] ++
    (map (feature: map (flag: strings.enableFeature feature.enabled flag) feature.flags) features);

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
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ fpletz globin orivej oxzi ajs124 ];
  };
}

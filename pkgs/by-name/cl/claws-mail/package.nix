{
  stdenv,
  lib,
  fetchurl,
  wrapGAppsHook3,
  autoreconfHook,
  bison,
  flex,
  curl,
  gtk3,
  pkg-config,
  python3,
  shared-mime-info,
  glib-networking,
  gsettings-desktop-schemas,

  # Package compatibility: old parameters whose name were not directly derived
  enablePgp ? true,
  enablePluginNotificationDialogs ? true,
  enablePluginNotificationSounds ? true,
  enablePluginPdf ? true,
  enablePluginRavatar ? true,
  enableSpellcheck ? true,

  # Arguments to include external libraries
  enableLibSM ? true,
  xorg,
  enableGnuTLS ? true,
  gnutls,
  enableEnchant ? enableSpellcheck,
  enchant,
  enableDbus ? true,
  dbus,
  dbus-glib,
  enableLdap ? true,
  openldap,
  enableNetworkManager ? true,
  networkmanager,
  enableLibetpan ? true,
  libetpan,
  enableValgrind ? !stdenv.hostPlatform.isDarwin && lib.meta.availableOn stdenv.hostPlatform valgrind,
  valgrind,
  enableSvg ? true,
  librsvg,

  # Configure claws-mail's plugins
  enablePluginAcpiNotifier ? true,
  enablePluginAddressKeeper ? true,
  enablePluginArchive ? true,
  libarchive,
  enablePluginAttRemover ? true,
  enablePluginAttachWarner ? true,
  enablePluginBogofilter ? true,
  enablePluginBsfilter ? true,
  enablePluginClamd ? true,
  enablePluginDillo ? true,
  enablePluginFancy ? true,
  webkitgtk_4_1,
  enablePluginFetchInfo ? true,
  enablePluginKeywordWarner ? true,
  enablePluginLibravatar ? enablePluginRavatar,
  enablePluginLitehtmlViewer ? true,
  gumbo,
  enablePluginMailmbox ? true,
  enablePluginManageSieve ? true,
  enablePluginNewMail ? true,
  enablePluginNotification ? (enablePluginNotificationDialogs || enablePluginNotificationSounds),
  libcanberra-gtk3,
  libnotify,
  enablePluginPdfViewer ? enablePluginPdf,
  poppler,
  enablePluginPerl ? true,
  perl,
  enablePluginPython ? true,
  enablePluginPgp ? enablePgp,
  gnupg,
  gpgme,
  enablePluginRssyl ? true,
  libxml2,
  enablePluginSmime ? true,
  enablePluginSpamassassin ? true,
  enablePluginSpamReport ? true,
  enablePluginTnefParse ? true,
  libytnef,
  enablePluginVcalendar ? true,
  libical,
}:

let
  pythonPkgs = with python3.pkgs; [
    python3
    wrapPython
    pygobject3
  ];

  features = [
    {
      flags = [ "acpi_notifier-plugin" ];
      enabled = enablePluginAcpiNotifier;
    }
    {
      flags = [ "address_keeper-plugin" ];
      enabled = enablePluginAddressKeeper;
    }
    {
      flags = [ "archive-plugin" ];
      enabled = enablePluginArchive;
      deps = [ libarchive ];
    }
    {
      flags = [ "att_remover-plugin" ];
      enabled = enablePluginAttRemover;
    }
    {
      flags = [ "attachwarner-plugin" ];
      enabled = enablePluginAttachWarner;
    }
    {
      flags = [ "bogofilter-plugin" ];
      enabled = enablePluginBogofilter;
    }
    {
      flags = [ "bsfilter-plugin" ];
      enabled = enablePluginBsfilter;
    }
    {
      flags = [ "clamd-plugin" ];
      enabled = enablePluginClamd;
    }
    {
      flags = [ "dbus" ];
      enabled = enableDbus;
      deps = [
        dbus
        dbus-glib
      ];
    }
    {
      flags = [ "dillo-plugin" ];
      enabled = enablePluginDillo;
    }
    {
      flags = [ "enchant" ];
      enabled = enableEnchant;
      deps = [ enchant ];
    }
    {
      flags = [ "fancy-plugin" ];
      enabled = enablePluginFancy;
      deps = [ webkitgtk_4_1 ];
    }
    {
      flags = [ "fetchinfo-plugin" ];
      enabled = enablePluginFetchInfo;
    }
    {
      flags = [ "keyword_warner-plugin" ];
      enabled = enablePluginKeywordWarner;
    }
    {
      flags = [ "gnutls" ];
      enabled = enableGnuTLS;
      deps = [ gnutls ];
    }
    {
      flags = [ "ldap" ];
      enabled = enableLdap;
      deps = [ openldap ];
    }
    {
      flags = [ "libetpan" ];
      enabled = enableLibetpan;
      deps = [ libetpan ];
    }
    {
      flags = [ "libravatar-plugin" ];
      enabled = enablePluginLibravatar;
    }
    {
      flags = [ "libsm" ];
      enabled = enableLibSM;
      deps = [ xorg.libSM ];
    }
    {
      flags = [ "litehtml_viewer-plugin" ];
      enabled = enablePluginLitehtmlViewer;
      deps = [ gumbo ];
    }
    {
      flags = [ "mailmbox-plugin" ];
      enabled = enablePluginMailmbox;
    }
    {
      flags = [ "managesieve-plugin" ];
      enabled = enablePluginManageSieve;
    }
    {
      flags = [ "networkmanager" ];
      enabled = enableNetworkManager;
      deps = [ networkmanager ];
    }
    {
      flags = [ "newmail-plugin" ];
      enabled = enablePluginNewMail;
    }
    {
      flags = [ "notification-plugin" ];
      enabled = enablePluginNotification;
      deps = [ libnotify ] ++ [ libcanberra-gtk3 ];
    }
    {
      flags = [ "pdf_viewer-plugin" ];
      enabled = enablePluginPdfViewer;
      deps = [ poppler ];
    }
    {
      flags = [ "perl-plugin" ];
      enabled = enablePluginPerl;
      deps = [ perl ];
    }
    {
      flags = [
        "pgpcore-plugin"
        "pgpinline-plugin"
        "pgpmime-plugin"
      ];
      enabled = enablePluginPgp;
      deps = [
        gnupg
        gpgme
      ];
    }
    {
      flags = [ "python-plugin" ];
      enabled = enablePluginPython;
    }
    {
      flags = [ "rssyl-plugin" ];
      enabled = enablePluginRssyl;
      deps = [ libxml2 ];
    }
    {
      flags = [ "smime-plugin" ];
      enabled = enablePluginSmime;
    }
    {
      flags = [ "spam_report-plugin" ];
      enabled = enablePluginSpamReport;
    }
    {
      flags = [ "spamassassin-plugin" ];
      enabled = enablePluginSpamassassin;
    }
    {
      flags = [ "svg" ];
      enabled = enableSvg;
      deps = [ librsvg ];
    }
    {
      flags = [ "tnef_parse-plugin" ];
      enabled = enablePluginTnefParse;
      deps = [ libytnef ];
    }
    {
      flags = [ "valgrind" ];
      enabled = enableValgrind;
      deps = [ valgrind ];
    }
    {
      flags = [ "vcalendar-plugin" ];
      enabled = enablePluginVcalendar;
      deps = [ libical ];
    }
  ];
in
stdenv.mkDerivation rec {
  pname = "claws-mail";
  version = "4.3.1";

  src = fetchurl {
    url = "https://claws-mail.org/download.php?file=releases/claws-mail-${version}.tar.xz";
    hash = "sha256-2K3yEMdnq1glLfxas8aeYD1//bcoGh4zQNLYYGL0aKY=";
  };

  outputs = [
    "out"
    "dev"
  ];

  patches = [
    ./mime.patch
  ];

  preConfigure = ''
    # autotools check tries to dlopen libpython as a requirement for the python plugin
    export LD_LIBRARY_PATH=$LD_LIBRARY_PATH''${LD_LIBRARY_PATH:+:}${python3}/lib
    # generate version without .git
    [ -e version ] || echo "echo ${version}" > version
  '';

  postPatch = ''
    substituteInPlace configure.ac \
      --replace 'm4_esyscmd([./get-git-version])' '${version}'
    substituteInPlace src/procmime.c \
        --subst-var-by MIMEROOTDIR ${shared-mime-info}/share
  '';

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    bison
    flex
    wrapGAppsHook3
  ];
  propagatedBuildInputs = pythonPkgs;

  buildInputs = [
    curl
    gsettings-desktop-schemas
    glib-networking
    gtk3
  ]
  ++ lib.concatMap (f: lib.optionals f.enabled f.deps) (lib.filter (f: f ? deps) features);

  configureFlags = [
    "--disable-manual" # Missing docbook-tools, e.g., docbook2html
    "--disable-compface" # Missing compface library
    "--disable-jpilot" # Missing jpilot library
  ]
  ++ (map (
    feature: map (flag: lib.strings.enableFeature feature.enabled flag) feature.flags
  ) features);

  enableParallelBuilding = true;

  preFixup = ''
    buildPythonPath "$out $pythonPkgs"
    gappsWrapperArgs+=(--prefix XDG_DATA_DIRS : "${shared-mime-info}/share" --prefix PYTHONPATH : "$program_PYTHONPATH")
  '';

  postInstall = ''
    mkdir -p $out/share/applications
    cp claws-mail.desktop $out/share/applications
  '';

  meta = with lib; {
    description = "User-friendly, lightweight, and fast email client";
    mainProgram = "claws-mail";
    homepage = "https://www.claws-mail.org/";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [
      fpletz
      globin
      orivej
      oxzi
      ajs124
    ];
  };
}

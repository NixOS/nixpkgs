{ stdenv
, fetchFromGitHub
, substituteAll
, plymouth
, pam
, pkgconfig
, autoconf
, automake
, libtool
, libxcb
, glib
, libXdmcp
, itstool
, intltool
, libxklavier
, libgcrypt
, audit
, busybox
, polkit
, accountsservice
, gtk-doc
, gnome3
, gobject-introspection
, vala
, fetchpatch
, withQt4 ? false
, qt4
, withQt5 ? false
, qtbase
, yelp-tools
}:

with stdenv.lib;

stdenv.mkDerivation rec {
  pname = "lightdm";
  version = "1.30.0";

  outputs = [ "out" "dev" ];

  src = fetchFromGitHub {
    owner = "CanonicalLtd";
    repo = pname;
    rev = version;
    sha256 = "0i1yygmjbkdjnqdl9jn8zsa1mfs2l19qc4k2capd8q1ndhnjm2dx";
  };

  nativeBuildInputs = [
    autoconf
    automake
    yelp-tools
    gnome3.yelp-xsl
    gobject-introspection
    gtk-doc
    intltool
    itstool
    libtool
    pkgconfig
    vala
  ];

  buildInputs = [
    accountsservice
    audit
    glib
    libXdmcp
    libgcrypt
    libxcb
    libxklavier
    pam
    polkit
  ] ++ optional withQt4 qt4
    ++ optional withQt5 qtbase;

  patches = [
    # Adds option to disable writing dmrc files
    (fetchpatch {
      url = "https://src.fedoraproject.org/rpms/lightdm/raw/4cf0d2bed8d1c68970b0322ccd5dbbbb7a0b12bc/f/lightdm-1.25.1-disable_dmrc.patch";
      sha256 = "06f7iabagrsiws2l75sx2jyljknr9js7ydn151p3qfi104d1541n";
    })

    # Don't use etc/dbus-1/system.d
    (fetchpatch {
      url = "https://github.com/canonical/lightdm/commit/a99376f5f51aa147aaf81287d7ce70db76022c47.patch";
      sha256 = "1zyx1qqajrmqcf9hbsapd39gmdanswd9l78rq7q6rdy4692il3yn";
    })

    # https://github.com/canonical/lightdm/pull/104
    (fetchpatch {
      url = "https://github.com/canonical/lightdm/commit/03f218981733e50d810767f9d04e42ee156f7feb.patch";
      sha256 = "07w18m2gpk29z6ym4y3lzsmg5dk3ffn39sq6lac26ap7narf4ma7";
    })

    # Hardcode plymouth to fix transitions.
    # For some reason it can't find `plymouth`
    # even when it's in PATH in environment.systemPackages.
    (substituteAll {
      src = ./fix-paths.patch;
      plymouth = "${plymouth}/bin/plymouth";
    })
  ];

  preConfigure = "NOCONFIGURE=1 ./autogen.sh";

  configureFlags = [
    "--localstatedir=/var"
    "--sysconfdir=/etc"
    "--disable-tests"
    "--disable-dmrc"
  ] ++ optional withQt4 "--enable-liblightdm-qt"
    ++ optional withQt5 "--enable-liblightdm-qt5";

  installFlags = [
    "sysconfdir=${placeholder "out"}/etc"
    "localstatedir=\${TMPDIR}"
  ];

  prePatch = ''
    substituteInPlace autogen.sh \
      --replace "which" "${busybox}/bin/which"

    substituteInPlace src/shared-data-manager.c \
      --replace /bin/rm ${busybox}/bin/rm
  '';

  postInstall = ''
    rm -rf $out/etc/apparmor.d $out/etc/init $out/etc/pam.d
  '';

  meta = {
    homepage = https://github.com/CanonicalLtd/lightdm;
    description = "A cross-desktop display manager";
    platforms = platforms.linux;
    license = licenses.gpl3;
    maintainers = with maintainers; [ ocharles worldofpeace ];
  };
}

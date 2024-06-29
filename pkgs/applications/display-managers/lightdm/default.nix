{ lib, stdenv
, buildPackages
, fetchFromGitHub
, nix-update-script
, substituteAll
, plymouth
, pam
, pkg-config
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
, gnome
, gobject-introspection
, vala
, fetchpatch
, withQt5 ? false
, qtbase
, yelp-tools
}:

stdenv.mkDerivation rec {
  pname = "lightdm";
  version = "1.32.0";

  outputs = [ "out" "dev" ];

  src = fetchFromGitHub {
    owner = "canonical";
    repo = pname;
    rev = version;
    sha256 = "sha256-ttNlhWD0Ran4d3QvZ+PxbFbSUGMkfrRm+hJdQxIDJvM=";
  };

  nativeBuildInputs = [
    autoconf
    automake
    yelp-tools
    gnome.yelp-xsl
    gobject-introspection
    gtk-doc
    intltool
    itstool
    libtool
    pkg-config
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
  ] ++ lib.optional withQt5 qtbase;

  patches = [
    # Adds option to disable writing dmrc files
    (fetchpatch {
      url = "https://src.fedoraproject.org/rpms/lightdm/raw/4cf0d2bed8d1c68970b0322ccd5dbbbb7a0b12bc/f/lightdm-1.25.1-disable_dmrc.patch";
      sha256 = "06f7iabagrsiws2l75sx2jyljknr9js7ydn151p3qfi104d1541n";
    })

    # Hardcode plymouth to fix transitions.
    # For some reason it can't find `plymouth`
    # even when it's in PATH in environment.systemPackages.
    (substituteAll {
      src = ./fix-paths.patch;
      plymouth = "${plymouth}/bin/plymouth";
    })
  ];

  dontWrapQtApps = true;

  preConfigure = "NOCONFIGURE=1 ./autogen.sh";

  configureFlags = [
    "--localstatedir=/var"
    "--sysconfdir=/etc"
    "--disable-tests"
    "--disable-dmrc"
  ] ++ lib.optional withQt5 "--enable-liblightdm-qt5";

  installFlags = [
    "sysconfdir=${placeholder "out"}/etc"
    "localstatedir=\${TMPDIR}"
  ];

  prePatch = ''
    substituteInPlace autogen.sh \
      --replace "which" "${buildPackages.busybox}/bin/which"

    substituteInPlace src/shared-data-manager.c \
      --replace /bin/rm ${busybox}/bin/rm
  '';

  postInstall = ''
    rm -rf $out/etc/apparmor.d $out/etc/init $out/etc/pam.d
  '';

  passthru = {
    updateScript = nix-update-script { };
  };


  meta = with lib; {
    homepage = "https://github.com/canonical/lightdm";
    description = "Cross-desktop display manager";
    platforms = platforms.linux;
    license = licenses.gpl3;
    maintainers = with maintainers; [ ] ++ teams.pantheon.members;
  };
}

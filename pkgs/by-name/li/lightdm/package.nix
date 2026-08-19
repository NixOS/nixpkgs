{
  lib,
  stdenv,
  buildPackages,
  fetchFromGitHub,
  nix-update-script,
  replaceVars,
  plymouth,
  pam,
  pkg-config,
  autoreconfHook,
  gettext,
  libtool,
  libxcb,
  glib,
  libxdmcp,
  itstool,
  intltool,
  libxklavier,
  libgcrypt,
  audit,
  busybox,
  polkit,
  accountsservice,
  gtk-doc,
  gobject-introspection,
  vala,
  fetchpatch,
  withQt5 ? false,
  qt5,
  withQt6 ? false,
  qt6,
  yelp-tools,
  yelp-xsl,
  nixosTests,
}:

assert !(withQt5 && withQt6);

stdenv.mkDerivation (finalAttrs: {
  pname = "lightdm";
  version = "1.33.0";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitHub {
    owner = "ubuntu";
    repo = "lightdm";
    tag = finalAttrs.version;
    hash = "sha256-/OgG3jtqxCl3tAXHs+LaAkEAAun+bsUm5pZBffv1AWg=";
  };

  nativeBuildInputs = [
    autoreconfHook
    gettext
    yelp-tools
    yelp-xsl
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
    libxdmcp
    libgcrypt
    libxcb
    libxklavier
    pam
    polkit
  ]
  ++ lib.optional withQt5 qt5.qtbase
  ++ lib.optional withQt6 qt6.qtbase;

  patches = [
    # Adds option to disable writing dmrc files
    (fetchpatch {
      url = "https://src.fedoraproject.org/rpms/lightdm/raw/4cf0d2bed8d1c68970b0322ccd5dbbbb7a0b12bc/f/lightdm-1.25.1-disable_dmrc.patch";
      hash = "sha256-NpASGgEhOjxuKME2f7RM2U5JvRRdl0OF5lHnp5aKxxk=";
    })

    # Hardcode plymouth to fix transitions.
    # For some reason it can't find `plymouth`
    # even when it's in PATH in environment.systemPackages.
    (replaceVars ./fix-paths.patch {
      plymouth = "${plymouth}/bin/plymouth";
    })
  ];

  dontWrapQtApps = true;

  preConfigure =
    lib.optionalString withQt6 ''
      # See m4/qt-validate-moc.m4 for how moc is found.
      export PATH=${buildPackages.qt6Packages.qtbase}/libexec:$PATH
    ''
    + ''
      NOCONFIGURE=1 ./autogen.sh
    '';

  configureFlags = [
    "--localstatedir=/var"
    "--sysconfdir=/etc"
    "--disable-tests"
    "--disable-dmrc"
  ]
  ++ lib.optional withQt5 "--enable-liblightdm-qt5"
  ++ lib.optional withQt6 "--enable-liblightdm-qt6";

  installFlags = [
    "sysconfdir=${placeholder "out"}/etc"
    "localstatedir=\${TMPDIR}"
  ];

  postPatch = ''
    substituteInPlace autogen.sh \
      --replace-fail "which" "${buildPackages.busybox}/bin/which"

    substituteInPlace src/shared-data-manager.c \
      --replace-fail /bin/rm ${busybox}/bin/rm

    # Fix switching users
    # https://github.com/ubuntu/lightdm/pull/454
    substituteInPlace src/lightdm.c --replace-fail \
      "gboolean can_multi_session = login1_seat_get_can_multi_session (login1_seat);" \
      "gboolean can_multi_session = TRUE;"
  '';

  postInstall = ''
    rm -rf $out/etc/apparmor.d $out/etc/init $out/etc/pam.d
  '';

  passthru = {
    updateScript = nix-update-script { };
    tests = { inherit (nixosTests) lightdm; };
  };

  meta = {
    homepage = "https://github.com/ubuntu/lightdm";
    description = "Cross-desktop display manager";
    platforms = lib.platforms.linux;
    license = with lib.licenses; [
      gpl3Plus
      # and (
      lgpl2Only
      # or
      lgpl3Only
      # )
    ];
    teams = [ lib.teams.pantheon ];
  };
})

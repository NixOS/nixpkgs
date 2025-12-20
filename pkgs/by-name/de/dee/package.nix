{
  lib,
  stdenv,
  fetchgit,
  fetchpatch,
  pkg-config,
  glib,
  icu,
  gobject-introspection,
  dbus-glib,
  vala,
  python3,
  autoreconfHook,
  gtk-doc,
}:

stdenv.mkDerivation {
  pname = "dee";
  version = "unstable-2017-06-16";

  outputs = [
    "out"
    "dev"
    "py"
  ];

  src = fetchgit {
    url = "https://git.launchpad.net/ubuntu/+source/dee";
    rev = "applied/1.2.7+17.10.20170616-8build1";
    hash = "sha256-ttfppqb0t8cOhWaB97uyD9heVZKlBKYF2zD6yRwPyos=";
  };

  patches = [
    # Fixes glib 2.62 deprecations
    (fetchpatch {
      name = "dee-1.2.7-deprecated-g_type_class_add_private.patch";
      url = "https://src.fedoraproject.org/rpms/dee/raw/1a9a4ce3377074fabfca653ffe0287cd73aef82f/f/dee-1.2.7-deprecated-g_type_class_add_private.patch";
      sha256 = "13nyprq7bb7lnzkcb7frcpzidbl836ycn5bvmwa2k0nhmj6ycbx5";
    })
  ];

  nativeBuildInputs = [
    pkg-config
    vala
    autoreconfHook
    gobject-introspection
    python3
    gtk-doc
  ];

  buildInputs = [
    glib
    icu
    dbus-glib
  ];

  configureFlags = [
    "--disable-gtk-doc"
    "--with-pygi-overrides-dir=${placeholder "py"}/${python3.sitePackages}/gi/overrides"
  ];

  # Compilation fails after a change in glib where
  # g_string_free now returns a value
  env.NIX_CFLAGS_COMPILE = "-Wno-error=unused-result";

  enableParallelBuilding = true;

  meta = {
    description = "Library that uses DBus to provide objects allowing you to create Model-View-Controller type programs across DBus";
    mainProgram = "dee-tool";
    homepage = "https://launchpad.net/dee";
    license = lib.licenses.lgpl3;
    platforms = lib.platforms.linux;
    maintainers = [ ];
  };
}

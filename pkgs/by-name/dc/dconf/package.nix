{
  lib,
  stdenv,
  fetchurl,
  meson,
  mesonEmulatorHook,
  ninja,
  python3,
  vala,
  libxslt,
  pkg-config,
  glib,
  bash-completion,
  dbus,
  gnome,
  gtk-doc,
  docbook-xsl-nons,
  docbook_xml_dtd_42,
  nixosTests,
  buildPackages,
  gobject-introspection,
  withIntrospection ?
    lib.meta.availableOn stdenv.hostPlatform gobject-introspection
    && stdenv.hostPlatform.emulatorAvailable buildPackages,
  withDocs ? withIntrospection,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "dconf";
  version = "51.beta";

  outputs = [
    "out"
    "lib"
    "dev"
  ]
  ++ lib.optional withDocs "devdoc";

  src = fetchurl {
    url = "mirror://gnome/sources/dconf/${lib.versions.major finalAttrs.version}/dconf-${finalAttrs.version}.tar.xz";
    sha256 = "0N4IhSdzWqcsCbOXd51bH8rVbnCtcxhARN1jXf8IxLg=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    python3
    libxslt
    glib
    docbook-xsl-nons
    docbook_xml_dtd_42
    gtk-doc
  ]
  ++ lib.optionals (withDocs && !stdenv.buildPlatform.canExecute stdenv.hostPlatform) [
    mesonEmulatorHook # gtkdoc invokes the host binary to produce documentation
  ];

  buildInputs = [
    glib
    bash-completion
    dbus
  ]
  ++ lib.optionals withIntrospection [
    vala
  ];

  mesonFlags = [
    "--sysconfdir=/etc"
    (lib.mesonBool "gtk_doc" withDocs)
    (lib.mesonBool "vapi" withIntrospection)
  ];

  nativeCheckInputs = [
    dbus # for dbus-daemon
  ];

  doCheck =
    !stdenv.hostPlatform.isAarch32 && !stdenv.hostPlatform.isAarch64 && !stdenv.hostPlatform.isDarwin;

  postPatch = ''
    chmod +x tests/test-dconf.py tests/shellcheck.sh
    patchShebangs tests/test-dconf.py tests/shellcheck.sh
  '';

  passthru = {
    updateScript = gnome.updateScript {
      packageName = "dconf";
    };
    tests = { inherit (nixosTests) dconf; };
  };

  meta = {
    homepage = "https://gitlab.gnome.org/GNOME/dconf";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.unix;
    badPlatforms = [
      # Mandatory libdconfsettings shared library.
      lib.systems.inspect.platformPatterns.isStatic
    ];
    teams = [ lib.teams.gnome ];
    mainProgram = "dconf";
  };
})

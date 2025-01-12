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

stdenv.mkDerivation rec {
  pname = "dconf";
  version = "0.40.0";

  outputs = [
    "out"
    "lib"
    "dev"
  ] ++ lib.optional withDocs "devdoc";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "0cs5nayg080y8pb9b7qccm1ni8wkicdmqp1jsgc22110r6j24zyg";
  };

  nativeBuildInputs =
    [
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

  buildInputs =
    [
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
    chmod +x meson_post_install.py tests/test-dconf.py
    patchShebangs meson_post_install.py
    patchShebangs tests/test-dconf.py
  '';

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
      versionPolicy = "odd-unstable";
    };
    tests = { inherit (nixosTests) dconf; };
  };

  meta = with lib; {
    homepage = "https://gitlab.gnome.org/GNOME/dconf";
    license = licenses.lgpl21Plus;
    platforms = platforms.unix;
    maintainers = teams.gnome.members;
    mainProgram = "dconf";
  };
}

{
  stdenv,
  lib,
  fetchurl,
  meson,
  mesonEmulatorHook,
  ninja,
  pkg-config,
  exiv2,
  glib,
  gnome,
  gobject-introspection,
  vala,
  gi-docgen,
  python3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gexiv2";
  version = "0.15.2";

  outputs = [
    "out"
    "dev"
    "devdoc"
  ];

  src = fetchurl {
    url = "mirror://gnome/sources/gexiv2/${lib.versions.majorMinor finalAttrs.version}/gexiv2-${finalAttrs.version}.tar.xz";
    sha256 = "o6JSMNzPjFilTEw8ZLkm/pSMI9w5ENN/+yaKYwXl+6w=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    gobject-introspection
    vala
    gi-docgen
    (python3.pythonOnBuildForHost.withPackages (ps: [ ps.pygobject3 ]))
  ]
  ++ lib.optionals (!stdenv.buildPlatform.canExecute stdenv.hostPlatform) [
    mesonEmulatorHook
  ];

  buildInputs = [
    glib
  ];

  propagatedBuildInputs = [
    exiv2
  ];

  mesonFlags = [
    "-Dgtk_doc=true"
    "-Dtests=true"
  ];

  doCheck = true;

  preCheck =
    let
      libSuffix = if stdenv.hostPlatform.isDarwin then "4.dylib" else "so.4";
    in
    ''
      # Our gobject-introspection patches make the shared library paths absolute
      # in the GIR files. When running unit tests, the library is not yet installed,
      # though, so we need to replace the absolute path with a local one during build.
      # We are using a symlink that will be overridden during installation.
      mkdir -p $out/lib
      ln -s $PWD/gexiv2/libgexiv2-0.16.${libSuffix} $out/lib/libgexiv2-0.16.${libSuffix}
    '';

  postFixup = ''
    # Cannot be in postInstall, otherwise _multioutDocs hook in preFixup will move right back.
    moveToOutput "share/doc" "$devdoc"
  '';

  passthru = {
    updateScript = gnome.updateScript {
      packageName = "gexiv2";
      versionPolicy = "odd-unstable";
    };
  };

  meta = with lib; {
    homepage = "https://gitlab.gnome.org/GNOME/gexiv2";
    description = "GObject wrapper around the Exiv2 photo metadata library";
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
    teams = [ teams.gnome ];
  };
})

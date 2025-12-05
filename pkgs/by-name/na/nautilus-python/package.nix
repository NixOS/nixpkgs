{
  stdenv,
  lib,
  replaceVars,
  fetchurl,
  meson,
  ninja,
  pkg-config,
  gtk-doc,
  docbook-xsl-nons,
  docbook_xml_dtd_412,
  python3,
  nautilus,
  gnome,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "nautilus-python";
  version = "4.1.0";

  outputs = [
    "out"
    "dev"
    "doc"
    "devdoc"
  ];

  src = fetchurl {
    url = "mirror://gnome/sources/nautilus-python/${lib.versions.majorMinor finalAttrs.version}/nautilus-python-${finalAttrs.version}.tar.xz";
    hash = "sha256-/EpEi8yxoJtohlQJueKu0XHSii1ayA975E9fzKhO4ME=";
  };

  patches = [
    # Make PyGObject’s gi library available.
    (replaceVars ./fix-paths.patch {
      pythonPaths = lib.concatMapStringsSep ", " (pkg: "'${pkg}/${python3.sitePackages}'") [
        python3.pkgs.pygobject3
      ];
    })
  ];

  nativeBuildInputs = [
    pkg-config
    meson
    ninja
    gtk-doc
    docbook-xsl-nons
    docbook_xml_dtd_412
    python3.pythonOnBuildForHost
  ];

  buildInputs = [
    python3
    python3.pkgs.pygobject3
    nautilus
  ];

  passthru = {
    updateScript = gnome.updateScript {
      packageName = "nautilus-python";
    };
  };

  meta = with lib; {
    description = "Python bindings for the Nautilus Extension API";
    homepage = "https://gitlab.gnome.org/GNOME/nautilus-python";
    license = licenses.gpl2Plus;
    teams = [ teams.gnome ];
    platforms = platforms.unix;
  };
})

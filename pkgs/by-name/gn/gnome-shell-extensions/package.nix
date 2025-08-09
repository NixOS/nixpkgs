{
  lib,
  stdenv,
  fetchurl,
  meson,
  ninja,
  gettext,
  pkg-config,
  libgtop,
  glib,
  gnome,
  gnome-menus,
  replaceVars,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gnome-shell-extensions";
  version = "48.3";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-shell-extensions/${lib.versions.major finalAttrs.version}/gnome-shell-extensions-${finalAttrs.version}.tar.xz";
    hash = "sha256-rd40wI9AtjQRvm8dF+I1VQoAkElIceZIHDEpidf0otQ=";
  };

  patches = [
    (replaceVars ./fix_gmenu.patch {
      gmenu_path = "${gnome-menus}/lib/girepository-1.0";
    })
    (replaceVars ./fix_gtop.patch {
      gtop_path = "${libgtop}/lib/girepository-1.0";
    })
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    gettext
    glib
  ];

  mesonFlags = [ "-Dextension_set=all" ];

  preFixup = ''
    # Since we do not install the schemas to central location,
    # let’s link them to where extensions installed
    # through the extension portal would look for them.
    # Adapted from export-zips.sh in the source.

    extensiondir=$out/share/gnome-shell/extensions
    schemadir=${glib.makeSchemaPath "$out" "$name"}

    for f in $extensiondir/*; do
      name=$(basename "''${f%%@*}")
      schema=$schemadir/org.gnome.shell.extensions.$name.gschema.xml
      schemas_compiled=$schemadir/gschemas.compiled

      if [[ -f $schema ]]; then
        mkdir "$f/schemas"
        ln -s "$schema" "$f/schemas"
        ln -s "$schemas_compiled" "$f/schemas"
      fi
    done
  '';

  passthru = {
    updateScript = gnome.updateScript { packageName = "gnome-shell-extensions"; };
  };

  meta = with lib; {
    homepage = "https://gitlab.gnome.org/GNOME/gnome-shell-extensions";
    changelog = "https://gitlab.gnome.org/GNOME/gnome-shell-extensions/-/blob/${finalAttrs.version}/NEWS?ref_type=tags";
    description = "Modify and extend GNOME Shell functionality and behavior";
    teams = [ teams.gnome ];
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
})

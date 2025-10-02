{
  stdenv,
  lib,
  fetchurl,
  gi-docgen,
  gobject-introspection,
  meson,
  ninja,
  pkg-config,
  vala,
  glib,
  liburing,
  gnome,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libdex";
  version = "0.10.1";

  outputs = [
    "out"
    "dev"
    "devdoc"
  ];

  src = fetchurl {
    url = "mirror://gnome/sources/libdex/${lib.versions.majorMinor finalAttrs.version}/libdex-${finalAttrs.version}.tar.xz";
    hash = "sha256-dHLogJDbKyKDB1Be3rpEg+hyaBNAywQErmSsPaW+0KY=";
  };

  nativeBuildInputs = [
    gi-docgen
    gobject-introspection
    meson
    ninja
    pkg-config
    vala
  ];

  buildInputs = [
    glib
    liburing
  ];

  mesonFlags = [
    "-Ddocs=true"
  ];

  doCheck = true;

  postFixup = ''
    # Cannot be in postInstall, otherwise _multioutDocs hook in preFixup will move right back.
    moveToOutput "share/doc" "$devdoc"
  '';

  passthru.updateScript = gnome.updateScript {
    packageName = "libdex";
    versionPolicy = "odd-unstable";
  };

  meta = with lib; {
    description = "Library supporting deferred execution for GNOME and GTK";
    homepage = "https://gitlab.gnome.org/GNOME/libdex";
    teams = [ teams.gnome ];
    platforms = platforms.linux ++ platforms.darwin;
    license = licenses.lgpl21Plus;
  };
})

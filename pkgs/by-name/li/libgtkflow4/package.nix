{
  stdenv,
  lib,
  vala,
  meson,
  ninja,
  pkg-config,
  fetchFromGitea,
  gobject-introspection,
  glib,
  gtk4,
  libgflow,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libgtkflow4";
  version = "0.2.6";

  outputs = [
    "out"
    "dev"
    "devdoc"
  ];
  outputBin = "devdoc"; # demo app

  src = fetchFromGitea {
    domain = "notabug.org";
    owner = "grindhold";
    repo = "libgtkflow";
    rev = "gtkflow4_${finalAttrs.version}";
    hash = "sha256-JoVq7U5JQ3pRxptR7igWFw7lcBTsgr3aVXxayLqhyFo=";
  };

  nativeBuildInputs = [
    vala
    meson
    ninja
    pkg-config
    gobject-introspection
  ];

  buildInputs = [
    gtk4
    glib
    libgflow
  ];

  postFixup = ''
    # Cannot be in postInstall, otherwise _multioutDocs hook in preFixup will move right back.
    moveToOutput "share/doc" "$devdoc"
  '';

  mesonFlags = [
    "-Denable_valadoc=true"
    "-Denable_gtk3=false"
    "-Denable_gflow=false"
  ];

  postPatch = ''
    rm -r libgflow
  '';

  meta = {
    description = "Flow graph widget for GTK 3";
    homepage = "https://notabug.org/grindhold/libgtkflow";
    maintainers = with lib.maintainers; [ grindhold ];
    license = lib.licenses.lgpl3Plus;
    platforms = lib.platforms.unix;
  };
})

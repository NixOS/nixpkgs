{
  pkg-config,
  libgee,
  ninja,
  gtk-layer-shell,
  lib,
  stdenv,
  makeWrapper,
  fetchgit,
  json-glib,
  gettext,
  fetchFromGitHub,
  gobject-introspection,
  intltool,
  gtk3,
  tinysparql,
  meson,
  vala,
  cmake,
}:

stdenv.mkDerivation {
  pname = "ilia";
  version = "3.1";
  src = fetchFromGitHub {
    owner = "regolith-linux";
    repo = "ilia";
    rev = "r3_1-ubuntu-jammy";
    hash = "sha256-4MKVwaepLOaxHFSwiks5InDbKt+B/Q2c97mM5yHz4eU=";
  };

  buildInputs = [
    makeWrapper
    json-glib
    gettext
    gobject-introspection
    intltool
    gtk3
    tinysparql
    meson
    vala
    cmake
    pkg-config
    libgee
    ninja
    gtk-layer-shell
  ];

  installPhase = ''
    mkdir -p $out/bin $out/share $out/share/glib-2.0/schemas
    cp src/ilia $out/share
    runHook postInstall
  '';

  postInstall = ''
    glib-compile-schemas --targetdir=$out/share/glib-2.0/schemas $src/data
    makeWrapper $out/share/ilia $out/bin/ilia --set GSETTINGS_SCHEMA_DIR $out/share/gsettings-schemas/ilia-3.1/glib-2.0/schemas
  '';

  meta = {
    description = "GTK-based Desktop Executor";
    homepage = "https://github.com/regolith-linux/ilia";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ sandptel ];
    mainProgram = "ilia";
    platforms = lib.platforms.linux;
  };
}

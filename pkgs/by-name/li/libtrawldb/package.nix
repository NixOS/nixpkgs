{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  cmake,
  json-glib,
  gettext,
  gobject-introspection,
  intltool,
  gtk3,
  tinysparql,
  vala,
  libgee,
  gtk-layer-shell,
  glib,
}:

stdenv.mkDerivation rec {
  pname = "libtrawldb";
  version = "0.1-3";

  src = fetchFromGitHub {
    owner = "regolith-linux";
    repo = "libtrawldb";
    rev = "v${version}";
    hash = "sha256-MqneoDFemBFf4PdX/hEfOB6ml4Rtjb1HF4R5QXfwiYE=";
  };

  nativeBuildInputs = [
    meson
    pkg-config
    cmake
    ninja
    json-glib
    gettext
    gobject-introspection
    intltool
    gtk3
    tinysparql
    vala
    libgee
    gtk-layer-shell
    glib
  ];

  installPhase = ''
    mkdir -p $out
    meson install --destdir $out
    ninja
    mkdir -p $out/lib
    cp -r $out/usr/lib $out
    cp -r $out/nix/store/*/* $out
    rm -rf $out/nix
  '';

  meta = {
    description = "C bindings for trawl";
    homepage = "https://github.com/regolith-linux/libtrawldb";
    changelog = "https://github.com/regolith-linux/libtrawldb/releases/tag/v${version}";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ sandptel ];
    mainProgram = "libtrawldb";
    platforms = lib.platforms.linux;
  };
}

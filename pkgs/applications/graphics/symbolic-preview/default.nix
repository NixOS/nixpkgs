{
  lib,
  stdenv,
  fetchurl,
  wrapGAppsHook4,
  cargo,
  desktop-file-utils,
  meson,
  ninja,
  pkg-config,
  rustc,
  glib,
  gtk4,
  libadwaita,
  libxml2,
}:

stdenv.mkDerivation rec {
  pname = "symbolic-preview";
  version = "0.0.9";

  src = fetchurl {
    url = "https://gitlab.gnome.org/World/design/symbolic-preview/uploads/e2fed158fc0d267f2051302bcf14848b/symbolic-preview-${version}.tar.xz";
    hash = "sha256-kx+70LCQzzWAw2Xd3fKGq941540IM3Y1+r4Em4MNWbw=";
  };

  nativeBuildInputs = [
    cargo
    desktop-file-utils
    meson
    ninja
    pkg-config
    rustc
    wrapGAppsHook4
  ];
  buildInputs = [
    glib
    gtk4
    libadwaita
    libxml2
  ];

  meta = with lib; {
    homepage = "https://gitlab.gnome.org/World/design/symbolic-preview";
    description = "Symbolics made easy";
    mainProgram = "symbolic-preview";
    maintainers = with maintainers; [ qyliss ];
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
    # never built on aarch64-darwin, x86_64-darwin since first introduction in nixpkgs
    broken = stdenv.isDarwin;
  };
}

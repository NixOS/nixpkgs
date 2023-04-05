{ lib
, stdenv
, fetchFromGitLab
, rustPlatform
, pkg-config
, meson
, ninja
, glib
, gobject-introspection
, libadwaita
, libxml2
, librsvg
, wrapGAppsHook4
, appstream-glib
, desktop-file-utils
}:

stdenv.mkDerivation rec {
  pname = "emblem";
  version = "1.1.0";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "World/design";
    repo = pname;
    rev = version;
    sha256 = "sha256-kNPV1SHkNTBXbMzDJGuDbaGz1WkBqMpVgZKjsh7ejmo=";
  };

  cargoDeps = rustPlatform.importCargoLock {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "librsvg-2.55.90" = "sha256-IegUvM1HcsRiYS6woaP1aeWKtgBxim9FkdZY9BSscPY=";
    };
  };

  nativeBuildInputs = [
    appstream-glib
    glib
    gobject-introspection
    meson
    ninja
    pkg-config
    wrapGAppsHook4
  ] ++ (with rustPlatform; [
    cargoSetupHook
    rust.cargo
    rust.rustc
  ]);

  buildInputs = [
    desktop-file-utils
    libadwaita
    librsvg
    libxml2
  ];

  meta = with lib; {
    description = "Generate project icons and avatars from a symbolic icon";
    homepage = "https://gitlab.gnome.org/World/design/emblem";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ foo-dogsquared ];
  };
}

{ lib
, stdenv
, fetchFromGitLab
, rustPlatform
, appstream-glib
, cargo
, desktop-file-utils
, glib
, meson
, ninja
, pkg-config
, rustc
, wrapGAppsHook4
, gtk4
, libadwaita
, libxml2
, darwin
}:

stdenv.mkDerivation rec {
  pname = "emblem";
  version = "1.3.0";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    group = "World";
    owner = "design";
    repo = "emblem";
    rev = version;
    sha256 = "sha256-VA4KZ8x/MMAA/g/x59h1CyHhlj0vbZqwAFdsfTPA2Ds=";
  };

  cargoDeps = rustPlatform.importCargoLock {
    lockFile = ./Cargo.lock;
  };

  nativeBuildInputs = [
    appstream-glib
    desktop-file-utils
    glib
    meson
    ninja
    pkg-config
    wrapGAppsHook4
    rustPlatform.cargoSetupHook
    cargo
    rustc
  ];

  buildInputs = [
    gtk4
    libadwaita
    libxml2
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Foundation
  ];

  meta = with lib; {
    description = "Generate project icons and avatars from a symbolic icon";
    mainProgram = "emblem";
    homepage = "https://gitlab.gnome.org/World/design/emblem";
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ figsoda foo-dogsquared ];
  };
}

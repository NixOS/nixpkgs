{ stdenv
, lib
, fetchFromGitLab
, cargo
, gettext
, meson
, ninja
, pkg-config
, rustPlatform
, rustc
, wrapGAppsHook4
, appstream-glib
, desktop-file-utils
, glib
, gtk4
, gdk-pixbuf
, libadwaita
, Foundation
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gnome-obfuscate";
  version = "0.0.10";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "World";
    repo = "Obfuscate";
    rev = finalAttrs.version;
    hash = "sha256-/Plvvn1tle8t/bsPcsamn5d81CqnyGCyGYPF6j6U5NI=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit (finalAttrs) src;
    name = "${finalAttrs.pname}-${finalAttrs.version}";
    hash = "sha256-9lrxK2psdIPGsOC6p8T+3AGPrX6PjrK9mFirdJqBSMM=";
  };

  nativeBuildInputs = [
    gettext
    meson
    ninja
    pkg-config
    rustPlatform.cargoSetupHook
    cargo
    rustc
    wrapGAppsHook4
    appstream-glib
    desktop-file-utils
  ];

  buildInputs = [
    glib
    gtk4
    gdk-pixbuf
    libadwaita
  ] ++ lib.optionals stdenv.isDarwin [
    Foundation
  ];

  meta = with lib; {
    description = "Censor private information";
    homepage = "https://gitlab.gnome.org/World/obfuscate";
    license = licenses.gpl3Plus;
    platforms = platforms.all;
    mainProgram = "obfuscate";
    maintainers = with maintainers; [ fgaz ];
  };
})

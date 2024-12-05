{ lib
, cargo
, desktop-file-utils
, fetchFromGitLab
, glib
, gtk4
, libadwaita
, meson
, ninja
, pkg-config
, rustPlatform
, rustc
, stdenv
, wrapGAppsHook4
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lorem";
  version = "1.4";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "World/design";
    repo = "lorem";
    rev = finalAttrs.version;
    hash = "sha256-6+kDKKK1bkIOZlqzKWpzpjAS5o7bkbVFITMZVmJijuU=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    src = finalAttrs.src;
    name = "${finalAttrs.pname}-${finalAttrs.version}";
    hash = "sha256-nzP2Jp9l1QgL7Wk9SWlsSVNaeVe3t48MmeX7Xuz+PKM=";
  };

  nativeBuildInputs = [
    cargo
    desktop-file-utils
    meson
    ninja
    pkg-config
    rustPlatform.cargoSetupHook
    rustc
    wrapGAppsHook4
  ];

  buildInputs = [
    glib
    gtk4
    libadwaita
  ];

  meta = with lib; {
    changelog = "https://gitlab.gnome.org/World/design/lorem/-/releases/${finalAttrs.version}";
    description = "Generate placeholder text";
    homepage = "https://apps.gnome.org/Lorem/";
    license = licenses.gpl3Plus;
    mainProgram = "lorem";
    maintainers = with maintainers; [ michaelgrahamevans ];
    platforms = platforms.linux;
  };
})

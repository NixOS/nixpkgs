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
  version = "0.0.9";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "World";
    repo = "Obfuscate";
    rev = finalAttrs.version;
    hash = "sha256-aUhzact437V/bSsG2Ddu2mC03LbyXFg+hJiuGy5NQfQ=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit (finalAttrs) src;
    name = "${finalAttrs.pname}-${finalAttrs.version}";
    hash = "sha256-HUQvdCmzjdmuJGDLtC/86yzbRimLzx+XbW29f+Ua48w=";
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

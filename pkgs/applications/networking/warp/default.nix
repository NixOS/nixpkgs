{ lib
, stdenv
, fetchFromGitLab
, appstream-glib
, desktop-file-utils
, itstool
, meson
, ninja
, pkg-config
, python3
, rustPlatform
, wrapGAppsHook4
, glib
, gtk4
, libadwaita
}:

stdenv.mkDerivation rec {
  pname = "warp";
  version = "0.3.2";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "World";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-oKkZC9fi5xPnLTI00MnG2gMjzMZHMNFI77ztbR4KQo4=";
  };

  postPatch = ''
    patchShebangs build-aux
  '';

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-sbyAyjxpol2SBxoLUsiPGfkP2diBPgJW0vEDHYWgmLU=";
  };

  nativeBuildInputs = [
    appstream-glib
    desktop-file-utils
    itstool
    meson
    ninja
    pkg-config
    python3
    wrapGAppsHook4
  ] ++ (with rustPlatform; [
    cargoSetupHook
    rust.cargo
    rust.rustc
  ]);

  buildInputs = [
    glib
    gtk4
    libadwaita
  ];

  meta = {
    description = "Fast and secure file transfer";
    homepage = "https://apps.gnome.org/app/app.drey.Warp";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ dotlambda ];
    platforms = lib.platforms.linux;
  };
}

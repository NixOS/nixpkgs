{
  lib,
  rustPlatform,
  fetchFromGitea,
  pkg-config,
  glib,
  gtk4,
  pipewire,
  dbus,
  wrapGAppsHook4,
  autoPatchelfHook,
}:
rustPlatform.buildRustPackage rec {
  pname = "sonusmix";
  version = "0.1.1";
  doCheck = false;

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "sonusmix";
    repo = "sonusmix";
    rev = "v${version}";
    hash = "sha256-vqbYJuErghSsvkFccLFUYuf1Dsg17tCBhF4/NLcba/E=";
  };

  cargoHash = "sha256-KiCJ8XOU5qnO0zB1K7XBTx35WWUpAmqPFkNZOIgwLA0=";

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
    wrapGAppsHook4
    autoPatchelfHook
  ];

  buildInputs = [
    glib
    gtk4
    pipewire
    dbus
  ];

  meta = {
    description = "Next-gen Pipewire audio routing tool";
    homepage = "https://codeberg.org/sonusmix/sonusmix";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ ];
    platforms = lib.platforms.linux;
    mainProgram = "sonusmix";
  };
}

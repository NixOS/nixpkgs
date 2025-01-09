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

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "libspa-0.8.0" = "sha256-R68TkFbzDFA/8Btcar+0omUErLyBMm4fsmQlCvfqR9o=";
    };
  };

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
    maintainers = with lib.maintainers; [ aucub ];
    platforms = lib.platforms.linux;
  };
}

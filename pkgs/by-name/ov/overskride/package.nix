{
  lib,
  fetchFromGitHub,
  rustPlatform,
  cargo,
  rustc,
  meson,
  ninja,
  pkg-config,
  wrapGAppsHook4,
  desktop-file-utils,
  appstream-glib,
  blueprint-compiler,
  dbus,
  gtk4,
  libadwaita,
  bluez,
  libpulseaudio,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "overskride";
  version = "0.6.2";

  src = fetchFromGitHub {
    owner = "kaii-lb";
    repo = "overskride";
    tag = "v${finalAttrs.version}";
    hash = "sha256-eMT0wNTpW75V08rmwFtU6NkmZ4auiujzYgbcktewNcI=";
  };

  cargoHash = "sha256-Axeywo7Ryig84rS/6MXl2v9Pe3yzdivq7/l/mfi5mOA=";

  nativeBuildInputs = [
    pkg-config
    wrapGAppsHook4
    desktop-file-utils
    appstream-glib
    blueprint-compiler
    meson
    ninja
    cargo
    rustc
  ];

  buildInputs = [
    dbus
    gtk4
    libadwaita
    bluez
    libpulseaudio
  ];

  buildPhase = ''
    runHook preBuild

    meson setup build --prefix $out && cd build
    meson compile && meson devenv

    runHook postBuild
  '';

  # The "Validate appstream file" test fails.
  doCheck = false;

  preFixup = ''
    glib-compile-schemas $out/share/gsettings-schemas/overskride-${finalAttrs.version}/glib-2.0/schemas
  '';

  meta = {
    description = "Bluetooth and Obex client that is straight to the point, DE/WM agnostic, and beautiful";
    homepage = "https://github.com/kaii-lb/overskride";
    changelog = "https://github.com/kaii-lb/overskride/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.gpl3Only;
    mainProgram = "overskride";
    maintainers = with lib.maintainers; [ mrcjkb ];
    platforms = lib.platforms.linux;
  };
})

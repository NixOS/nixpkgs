{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchFromGitLab,
  fetchpatch,
  blueprint-compiler,
  cargo,
  desktop-file-utils,
  meson,
  ninja,
  pkg-config,
  rustPlatform,
  rustc,
  wrapGAppsHook4,
  cairo,
  gdk-pixbuf,
  glib,
  gtk4,
  libadwaita,
  pango,
  pipewire,
  wireplumber,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pwvucontrol";
  version = "0.5.2";

  src = fetchFromGitHub {
    owner = "saivert";
    repo = "pwvucontrol";
    tag = finalAttrs.version;
    hash = "sha256-3H0qLhnhD/CVjKcx8UISFD4tSgH9O3V2uyNcgYug6Ug=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-k3a1I+M+rxXvABlgpsw6tFhTIgaxpsCUDwhuFQj6Nhc=";
  };

  postPatch = ''
    substituteInPlace src/meson.build --replace-fail \
      "'src' / rust_target / meson.project_name()," \
      "'src' / '${stdenv.hostPlatform.rust.cargoShortTarget}' / rust_target / meson.project_name(),"
  '';

  nativeBuildInputs = [
    blueprint-compiler
    cargo
    desktop-file-utils
    meson
    ninja
    pkg-config
    rustPlatform.bindgenHook
    rustPlatform.cargoSetupHook
    rustc
    wrapGAppsHook4
  ];

  buildInputs = [
    cairo
    gdk-pixbuf
    glib
    gtk4
    libadwaita
    pango
    pipewire
    wireplumber
  ];

  # For https://github.com/saivert/pwvucontrol/blob/7bf43c746cd49fffbfb244ac4474742c6b3737a9/src/meson.build#L45-L46
  env.CARGO_BUILD_TARGET = stdenv.hostPlatform.rust.rustcTargetSpec;

  meta = {
    description = "Pipewire Volume Control";
    homepage = "https://github.com/saivert/pwvucontrol";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      Guanran928
      johnrtitor
    ];
    mainProgram = "pwvucontrol";
    platforms = lib.platforms.linux;
  };
})

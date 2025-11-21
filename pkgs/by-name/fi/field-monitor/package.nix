{
  stdenv,
  lib,
  fetchFromGitHub,
  cargo,
  meson,
  ninja,
  rustPlatform,
  rustc,
  pkg-config,
  glib,
  gsettings-desktop-schemas,
  gtk4,
  libadwaita,
  libvirt,
  gst_all_1,
  desktop-file-utils,
  appstream,
  appstream-glib,
  wrapGAppsHook4,
  xdg-desktop-portal,
  blueprint-compiler,
  libxml2,
  spice-protocol,
  spice-gtk,
  vte-gtk4,
  gtk-vnc,
  usbredir,
  libepoxy,
  libGL,
  openssl,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "field-monitor";
  version = "49.0";

  src = fetchFromGitHub {
    owner = "theCapypara";
    repo = "field-monitor";
    tag = "v${finalAttrs.version}";
    hash = "sha256-hKxYwYcUClBfHhi4sfNCZBVADXPRKQxHUHZS6l7BV+A=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) src;
    hash = "sha256-sd+yQLEqMnNNEYofPCd8wXJeNh0TYBS/E9FzrzfGEsk=";
  };

  mesonBuildType = "release";

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    rustPlatform.cargoSetupHook
    cargo
    rustc
    desktop-file-utils
    appstream
    appstream-glib
    wrapGAppsHook4
    blueprint-compiler
    libxml2
    spice-protocol
    spice-gtk
    usbredir
    libepoxy
    libGL
    openssl
    vte-gtk4
    gtk-vnc
  ];

  buildInputs = [
    glib
    gtk4
    gsettings-desktop-schemas
    libadwaita
    libvirt
    xdg-desktop-portal
  ]
  ++ (with gst_all_1; [
    gstreamer
    gst-plugins-base
    gst-plugins-good
  ]);

  postInstall = ''
    wrapProgram $out/bin/de.capypara.FieldMonitor --prefix PATH ':' "$out/libexec"
  '';

  meta = {
    description = "Viewer for virtual machines and other external screens";
    homepage = "https://github.com/theCapypara/field-monitor";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ theCapypara ];
    platforms = lib.platforms.linux;
    mainProgram = "de.capypara.FieldMonitor";
  };
})

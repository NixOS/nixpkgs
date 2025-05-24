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
  freerdp,
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
  version = "48.0";

  src = fetchFromGitHub {
    owner = "theCapypara";
    repo = "field-monitor";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ma1ltI2sVNVpSoFd5H5Tq7fo/uepX1OzM1qIKvMFs8c=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) src;
    hash = "sha256-3FimnzO9ja0OLaPRrMipVePD6x6Di5VvZRG31V8NSfg=";
  };

  mesonBuildType = "release";

  postInstall = ''
    wrapProgram $out/bin/de.capypara.FieldMonitor --prefix PATH ':' "$out/libexec"
  '';

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
    freerdp
    spice-protocol
    spice-gtk
    usbredir
    libepoxy
    libGL
    openssl
    vte-gtk4
    gtk-vnc
  ];

  buildInputs =
    [
      glib
      gtk4
      gsettings-desktop-schemas
      libadwaita
      libvirt
      xdg-desktop-portal
      openssl
    ]
    ++ (with gst_all_1; [
      gstreamer
      gst-plugins-base
      gst-plugins-good
    ]);

  meta = {
    description = "Viewer for virtual machines and other external screens";
    homepage = "https://github.com/theCapypara/field-monitor";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ theCapypara ];
    platforms = lib.platforms.linux;
    mainProgram = "de.capypara.FieldMonitor";
  };
})

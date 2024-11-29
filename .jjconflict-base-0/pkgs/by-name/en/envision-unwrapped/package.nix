{
  appstream-glib,
  cairo,
  cargo,
  desktop-file-utils,
  fetchFromGitLab,
  gdb,
  gdk-pixbuf,
  git,
  glib,
  gtk4,
  gtksourceview5,
  lib,
  libadwaita,
  libgit2,
  libusb1,
  meson,
  ninja,
  nix-update-script,
  openssl,
  openxr-loader,
  pango,
  pkg-config,
  rustPlatform,
  rustc,
  stdenv,
  vte-gtk4,
  wrapGAppsHook4,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "envision-unwrapped";
  version = "0-unstable-2024-10-20";

  src = fetchFromGitLab {
    owner = "gabmus";
    repo = "envision";
    rev = "c40a4ad05a8e6ea99eed4a7d7d2098a08686e065";
    hash = "sha256-C/m5Hx52fFyuVI87EmHpe5YqjwDWoyveiXA0sJTt2NQ=";
  };

  strictDeps = true;

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit (finalAttrs) pname version src;
    hash = "sha256-I9UDCKrqU6TWcmHsSFwt1elplPwU+XTgyXiN2wtw5y0=";
  };

  nativeBuildInputs = [
    appstream-glib
    desktop-file-utils
    cargo
    git
    meson
    ninja
    pkg-config
    rustPlatform.cargoSetupHook
    rustc
    wrapGAppsHook4
  ];

  buildInputs = [
    cairo
    gdk-pixbuf
    glib
    gtk4
    gtksourceview5
    libadwaita
    libgit2
    libusb1
    openssl
    openxr-loader
    pango
    vte-gtk4
    zlib
  ];

  postInstall = ''
    wrapProgram $out/bin/envision \
      --prefix PATH : "${lib.makeBinPath [ gdb ]}"
  '';

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch=main" ]; };

  meta = {
    description = "UI for building, configuring and running Monado, the open source OpenXR runtime";
    homepage = "https://gitlab.com/gabmus/envision";
    license = lib.licenses.agpl3Only;
    mainProgram = "envision";
    maintainers = with lib.maintainers; [
      pandapip1
      Scrumplex
    ];
    platforms = lib.platforms.linux;
  };
})

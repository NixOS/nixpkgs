{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  cargo,
  meson,
  ninja,
  pkg-config,
  rustPlatform,
  rustc,
  wrapGAppsHook4,
  cairo,
  dbus,
  gdk-pixbuf,
  glib,
  gtk4,
  libadwaita,
  openssl,
  pango,
  pipewire,
  sqlite,
  desktop-file-utils,
  libxml2,
  libsecret,
  gnome,
  librsvg,
  webp-pixbuf-loader,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "euphonica";
  version = "0.99.7-beta-1";

  src = fetchFromGitHub {
    owner = "htkhiem";
    repo = "euphonica";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Te6/LAP4J1kW1aOvSVVrbLJSBfBwt3ia0dM7cBzOOD8=";
    fetchSubmodules = true;
  };

  passthru.updateScript = nix-update-script {
    # to be dropped once there are stable releases
    extraArgs = [
      "--version=unstable"
    ];
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-TRERgKHkQa+/32JS2xUiuXxg9bEsur1Z7hITbhQOFEM=";
  };

  mesonBuildType = "release";

  # Euphonica caches album art as WebP, and gdk-pixbuf's default loaders.cache
  # doesn't include a WebP loader, causing covers to fail to load repeatedly.
  # https://github.com/NixOS/nixpkgs/issues/557510
  postInstall = ''
    export GDK_PIXBUF_MODULE_FILE="${
      gnome._gdkPixbufCacheBuilder_DO_NOT_USE {
        extraLoaders = [
          librsvg
          webp-pixbuf-loader
        ];
      }
    }"
  '';

  nativeBuildInputs = [
    cargo
    meson
    ninja
    pkg-config
    rustPlatform.bindgenHook
    rustPlatform.cargoSetupHook
    rustc
    wrapGAppsHook4
    desktop-file-utils
  ];

  buildInputs = [
    cairo
    dbus
    gdk-pixbuf
    glib
    gtk4
    libadwaita
    openssl
    pango
    pipewire
    sqlite
    libxml2
    libsecret
  ];

  meta = {
    description = "MPD client with delusions of grandeur, made with Rust, GTK and Libadwaita";
    homepage = "https://github.com/htkhiem/euphonica";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      paperdigits
      aaravrav
      doronbehar
    ];
    mainProgram = "euphonica";
    platforms = with lib.platforms; linux;
  };
})

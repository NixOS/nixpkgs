{
  lib,
  rustPlatform,
  fetchFromForgejo,
  pkg-config,
  clang,
  libclang,
  makeWrapper,
  lua5_4,
  dbus,
  wayland,
  wayland-protocols,
  pipewire,
  vulkan-loader,
  libxkbcommon,
  libGL,
  sqlite,
  fontconfig,
  freetype,
  protobuf,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "moxnotify";
  version = "0.1.0-unstable-2026-05-09";

  src = fetchFromForgejo {
    domain = "git.r0chd.pl";
    owner = "mox-desktop";
    repo = "moxnotify";
    rev = "bc57c855579631fdd7dd755c8918827fc8405fdd";
    hash = "sha256-N6pYVU2LPC7Kc9y6gPc+rrWSvXEYJXN/NoCXmzY3uJg=";
  };

  cargoHash = "sha256-de6gM296GMbEntIbsTrQJQWK1SQiZCN8hBS+dqtQJqA=";

  nativeBuildInputs = [
    pkg-config
    clang
    makeWrapper
    protobuf
  ];

  buildInputs = [
    lua5_4
    dbus
    wayland
    wayland-protocols
    pipewire
    vulkan-loader
    libxkbcommon
    libGL
    sqlite
    fontconfig
    freetype
    libclang.lib
  ];

  # Set LIBCLANG_PATH for bindgen
  env.LIBCLANG_PATH = "${libclang.lib}/lib";

  # Workspace members - build both daemon and ctl
  cargoBuildFlags = [ "--workspace" ];
  cargoTestFlags = [ "--workspace" ];

  # Skip tests for now as they may require display/audio systems
  doCheck = false;

  # Install both binaries with proper names
  postInstall = ''
    # Install D-Bus service file
    mkdir -p $out/share/dbus-1/services
    substitute ${finalAttrs.src}/pl.mox.notify.service.in $out/share/dbus-1/services/pl.mox.notify.service \
      --replace-fail "@bindir@" "$out/bin"
  '';

  # Wrap binaries with runtime dependencies for graphics libraries
  postFixup = ''
    wrapProgram $out/bin/moxnotify \
      --prefix LD_LIBRARY_PATH : ${
        lib.makeLibraryPath [
          vulkan-loader
          libGL
        ]
      }
    wrapProgram $out/bin/moxctl \
      --prefix LD_LIBRARY_PATH : ${
        lib.makeLibraryPath [
          vulkan-loader
          libGL
        ]
      }
  '';

  meta = {
    description = "Feature-rich hardware-accelerated keyboard driven Wayland notification daemon";
    homepage = "https://github.com/mox-desktop/moxnotify";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ logger ];
    platforms = lib.platforms.linux; # Wayland-specific, Linux only
    mainProgram = "client";
  };
})

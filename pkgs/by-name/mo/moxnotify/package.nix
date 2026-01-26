{
  lib,
  rustPlatform,
  fetchFromGitHub,
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
}:

rustPlatform.buildRustPackage rec {
  pname = "moxnotify";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "mox-desktop";
    repo = "moxnotify";
    rev = "6726af08621072e0c95a147cf4ae63ea66c7e857";
    hash = "sha256-tTgY/813WaW3K8QKbj6qwCVKOAA8zMqy97Q7Z5qA0JM=";
  };

  cargoHash = "sha256-o2YyPa7bX9585lsicJjhj1xJ1jMdU5mlxbEn/6zSy8U=";

  nativeBuildInputs = [
    pkg-config
    clang
    makeWrapper
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
    # Rename binaries to have more descriptive names
    mv $out/bin/daemon $out/bin/moxnotify
    mv $out/bin/ctl $out/bin/moxctl

    # Install D-Bus service file
    mkdir -p $out/share/dbus-1/services
    substitute ${src}/pl.mox.notify.service.in $out/share/dbus-1/services/pl.mox.notify.service \
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
    mainProgram = "moxnotify";
  };
}

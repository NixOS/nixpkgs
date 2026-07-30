{
  lib,
  fetchFromGitHub,
  rustPlatform,
  alsa-lib,
  libGL,
  libx11,
  libxcursor,
  libxcb,
  libxi,
  libxkbcommon,
  openxr-loader,
  pkg-config,
  vulkan-loader,
  wayland,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "stardust-xr-server";
  version = "0.51.1";

  src = fetchFromGitHub {
    owner = "stardustxr";
    repo = "server";
    tag = finalAttrs.version;
    hash = "sha256-ntVc5fc1qMjR1FDqoNq35Y6PkG9VPNDVplyTpO6VhKA=";
  };

  patches = [
    # nixosTests/flatland hits a bug:
    # it is permissible for a client to create an xdg_toplevel
    # before binding wl_seat; weston-presentation-shm never
    # binds a wl_seat since it doesn't need to accept input
    # TODO(@Pandapip1): upstream
    ./fix-seat-unwrap-panic.patch
  ];

  cargoHash = "sha256-5HQkrkupBohmopGJh9t3JndVTU6cjbW0LgtBPb+YAr0=";

  __structuredAttrs = true;
  strictDeps = true;
  nativeBuildInputs = [
    pkg-config
  ];
  buildInputs = [
    alsa-lib
    wayland
  ];

  postFixup = ''
    patchelf $out/bin/stardust-xr-server --add-rpath ${
      lib.makeLibraryPath [
        # wgpu-hal hardcodes ash's runtime libvulkan dlopen() path (ash does expose an optional linked feature)
        vulkan-loader
        # Likewise, bevy_openxr doesn't use openxr's linked feature
        openxr-loader
        # x11-dl via winit x11
        libx11
        libxcursor
        libxi
        libxcb
        # x11rb via winit and xkbcommon-dl
        libxkbcommon
        # wgpu-hal I think
        libGL
      ]
    }
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Wayland compositor and display server for 3D applications";
    homepage = "https://stardustxr.org/";
    changelog = "https://github.com/StardustXR/server/releases";
    license = lib.licenses.gpl2Plus;
    mainProgram = "stardust-xr-server";
    teams = with lib.teams; [ stardust-xr ];
    platforms = lib.platforms.unix;
  };
})

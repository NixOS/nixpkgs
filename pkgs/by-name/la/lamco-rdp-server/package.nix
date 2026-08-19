{
  lib,
  rustPlatform,
  fetchurl,
  pkg-config,
  cmake,
  nasm,
  makeWrapper,
  pipewire,
  libva,
  libxkbcommon,
  wayland,
  libei,
  dbus,
  fuse3,
  pam,
  openssl,
  vulkan-loader,
  libGL,
  openh264,
  wl-clipboard,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "lamco-rdp-server";
  version = "1.4.4";

  __structuredAttrs = true;

  src = fetchurl {
    url = "https://github.com/lamco-admin/lamco-rdp-server/releases/download/v${finalAttrs.version}/lamco-rdp-server-${finalAttrs.version}.tar.xz";
    hash = "sha256-gMqzhHFpvRqZqhP1XAqMO3tUQRM6hRV5yhr7TKEeyek=";
  };

  # The release tarball vendors every crate (vendor/ + .cargo/config.toml), so
  # build fully offline from it rather than re-fetching with a cargoHash.
  cargoVendorDir = "vendor";

  # libva >= 2.22 added fields to VAEncPictureParameterBufferVP9 that the vendored
  # cros-libva 0.0.13 does not know about; add ..Default::default() so it compiles.
  patches = [ ./cros-libva-vp9-compat.patch ];
  postPatch = ''
    # The patch edits a vendored crate; clear its recorded checksum so the
    # offline cargo build does not reject the modified file.
    sed -i 's/"files":{[^}]*}/"files":{}/' vendor/cros-libva/.cargo-checksum.json
  '';

  nativeBuildInputs = [
    pkg-config
    cmake
    nasm
    makeWrapper
    rustPlatform.bindgenHook # sets LIBCLANG_PATH for bindgen-using -sys crates
  ];

  buildInputs = [
    pipewire
    libva
    libxkbcommon
    wayland
    libei
    dbus
    fuse3
    pam
    openssl
    vulkan-loader
    libGL
  ];

  buildNoDefaultFeatures = true;
  buildFeatures = [
    "pam-auth"
    "h264"
    "gui"
    "wayland"
    "libei"
    "wl-clipboard"
  ];

  # Tests need a live Wayland session; skip them in the sandbox.
  doCheck = false;

  postInstall = ''
    install -Dm644 packaging/systemd/lamco-rdp-server.service \
      "$out/lib/systemd/user/lamco-rdp-server.service"
    install -Dm644 packaging/dbus/io.lamco.RdpServer.service \
      "$out/share/dbus-1/services/io.lamco.RdpServer.service"
    install -Dm644 packaging/dbus/io.lamco.RdpServer.System.conf \
      "$out/share/dbus-1/system.d/io.lamco.RdpServer.System.conf"
    install -Dm644 packaging/polkit/io.lamco.RdpServer.policy \
      "$out/share/polkit-1/actions/io.lamco.RdpServer.policy"
    install -Dm644 data/io.lamco.rdp-server.desktop \
      "$out/share/applications/io.lamco.rdp-server.desktop"
    install -Dm644 data/io.lamco.rdp-server.metainfo.xml \
      "$out/share/metainfo/io.lamco.rdp-server.metainfo.xml"
    install -Dm644 data/icons/io.lamco.rdp-server.svg \
      "$out/share/icons/hicolor/scalable/apps/io.lamco.rdp-server.svg"
    for s in 32 48 64 128 256; do
      install -Dm644 "data/icons/io.lamco.rdp-server-$s.png" \
        "$out/share/icons/hicolor/''${s}x''${s}/apps/io.lamco.rdp-server.png"
    done
  '';

  # wgpu/Vulkan and Cisco OpenH264 are dlopen'd at runtime, and the wl-clipboard
  # feature shells out to wl-copy/wl-paste; make all discoverable.
  postFixup = ''
    for bin in lamco-rdp-server lamco-rdp-server-gui; do
      wrapProgram "$out/bin/$bin" \
        --prefix LD_LIBRARY_PATH : "${
          lib.makeLibraryPath [
            vulkan-loader
            libGL
            wayland
            libxkbcommon
            openh264
          ]
        }" \
        --prefix PATH : "${lib.makeBinPath [ wl-clipboard ]}"
    done
  '';

  meta = {
    description = "Native Wayland RDP server for GNOME, KDE, Sway and Hyprland (H.264, VA-API)";
    homepage = "https://lamco.ai/";
    changelog = "https://github.com/lamco-admin/lamco-rdp-server/releases/tag/v${finalAttrs.version}";
    # BUSL-1.1 is source-available and freely redistributable but not FOSS; users
    # must set allowUnfree. Converts to Apache-2.0 on the change date.
    license = lib.licenses.unfreeRedistributable;
    sourceProvenance = [ lib.sourceTypes.fromSource ];
    maintainers = [ lib.maintainers.glamberson ];
    platforms = lib.platforms.linux;
    mainProgram = "lamco-rdp-server";
  };
})

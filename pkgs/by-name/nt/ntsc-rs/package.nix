{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  pkg-config,
  makeWrapper,
  copyDesktopItems,
  makeDesktopItem,
  fontconfig,
  glib,
  gst_all_1,
  openssl,
  libGL,
  libxkbcommon,
  vulkan-loader,
  wayland,
  libx11,
  libxcursor,
  libxi,
  libxrandr,
}:

let
  # Upstream's Linux install instructions ask for the base, good, bad, ugly and
  # libav plugin sets: https://ntsc.rs/docs/standalone-installation/
  gstPlugins = with gst_all_1; [
    gstreamer
    gst-plugins-base
    gst-plugins-good
    gst-plugins-bad
    gst-plugins-ugly
    gst-libav
  ];
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "ntsc-rs";
  version = "0.9.6";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "ntsc-rs";
    repo = "ntsc-rs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Igb8FqxmbSCA2oZf0TJi8hA59xTCB27VKUGsE5Gnm0o=";
  };

  cargoHash = "sha256-TZHJC4C1MxWyONF1SQGqz0YMZVConjXIyCoFqIzEujc=";

  nativeBuildInputs = [
    copyDesktopItems
    makeWrapper
    pkg-config
  ];

  buildInputs = [
    fontconfig
    glib
    openssl
  ]
  ++ gstPlugins;

  # Only the standalone GUI and the CLI are built. The OpenFX plugin needs the
  # openfx git submodule, which the release tarball does not carry, and the
  # After Effects plugin is not useful on Linux.
  cargoBuildFlags = [
    "--package"
    "ntsc-rs-gui"
    "--bin"
    "ntsc-rs-standalone"
    "--bin"
    "ntsc-rs-cli"
  ];

  cargoTestFlags = [
    "--package"
    "ntsc-rs"
    "--package"
    "ntsc-rs-gui"
  ];

  postInstall = ''
    install -Dm444 assets/icon.svg $out/share/icons/hicolor/scalable/apps/ntsc-rs.svg
  '';

  postFixup = ''
    # winit and wgpu dlopen these; they are absent from the binary's DT_NEEDED.
    # wgpu tries Vulkan before falling back to GL, so vulkan-loader matters.
    patchelf --add-rpath "${
      lib.makeLibraryPath [
        libGL
        libx11
        libxcursor
        libxi
        libxkbcommon
        libxrandr
        vulkan-loader
        wayland
      ]
    }" $out/bin/ntsc-rs-standalone

    for bin in ntsc-rs-standalone ntsc-rs-cli; do
      wrapProgram $out/bin/$bin \
        --prefix GST_PLUGIN_SYSTEM_PATH_1_0 : "${
          lib.makeSearchPathOutput "lib" "lib/gstreamer-1.0" gstPlugins
        }"
    done
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "ntsc-rs";
      desktopName = "ntsc-rs";
      comment = "Analog video and VHS effect";
      exec = "ntsc-rs-standalone";
      icon = "ntsc-rs";
      categories = [
        "AudioVideo"
        "AudioVideoEditing"
        "Video"
      ];
    })
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Analog video and VHS effect for images and videos";
    homepage = "https://ntsc.rs/";
    changelog = "https://github.com/ntsc-rs/ntsc-rs/releases/tag/v${finalAttrs.version}";
    # The standalone GUI in crates/gui is GPL-3.0; the ntscrs library it builds
    # on is tri-licensed MIT/ISC/Apache-2.0.
    license = lib.licenses.gpl3Only;
    mainProgram = "ntsc-rs-standalone";
    maintainers = with lib.maintainers; [ kanagawamarcos ];
    platforms = lib.platforms.linux;
  };
})

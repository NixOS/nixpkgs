{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  wrapGAppsHook3,
  atk,
  bzip2,
  cairo,
  dbus,
  gdk-pixbuf,
  glib,
  gst_all_1,
  gtk3,
  libayatana-appindicator,
  libgit2,
  libpulseaudio,
  libsodium,
  libXtst,
  libvpx,
  libyuv,
  libopus,
  libaom,
  libxkbcommon,
  libsciter,
  xdotool,
  pam,
  pango,
  zlib,
  zstd,
  stdenv,
  alsa-lib,
  makeDesktopItem,
  copyDesktopItems,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rustdesk";
  version = "1.4.2";

  src = fetchFromGitHub {
    owner = "rustdesk";
    repo = "rustdesk";
    tag = finalAttrs.version;
    fetchSubmodules = true;
    hash = "sha256-ZUk/6r7HjlWAU7sUxbBxp9ZtxXUJftjcDy/V3LcMNPA=";
  };

  cargoHash = "sha256-b0jsW0208zKFMyoqKti8TuTNZL7hQ8PX7Gwm0faW4po=";

  patches = [
    ./make-build-reproducible.patch
  ];

  desktopItems = [
    (makeDesktopItem {
      name = "rustdesk";
      exec = finalAttrs.meta.mainProgram;
      icon = "rustdesk";
      desktopName = "RustDesk";
      comment = finalAttrs.meta.description;
      genericName = "Remote Desktop";
      categories = [ "Network" ];
      mimeTypes = [ "x-scheme-handler/rustdesk" ];
    })
  ];

  nativeBuildInputs = [
    copyDesktopItems
    pkg-config
    rustPlatform.bindgenHook
    wrapGAppsHook3
  ];

  buildFeatures = lib.optionals stdenv.hostPlatform.isLinux [ "linux-pkg-config" ];

  # Checks require an active X server
  doCheck = false;

  buildInputs = [
    atk
    bzip2
    cairo
    dbus
    gdk-pixbuf
    glib
    gst_all_1.gst-plugins-base
    gst_all_1.gstreamer
    gtk3
    libgit2
    libpulseaudio
    libsodium
    libXtst
    libvpx
    libyuv
    libopus
    libaom
    libxkbcommon
    pam
    pango
    zlib
    zstd
  ]

  ++ lib.optionals stdenv.hostPlatform.isLinux [
    alsa-lib
    xdotool
  ];

  # Add static ui resources and libsciter to same folder as binary so that it
  # can find them.
  postInstall = ''
    mkdir -p $out/{share/src,lib/rustdesk}

    # .so needs to be next to the executable
    mv $out/bin/rustdesk $out/lib/rustdesk
    ${lib.optionalString stdenv.hostPlatform.isLinux "ln -s ${libsciter}/lib/libsciter-gtk.so $out/lib/rustdesk"}

    makeWrapper $out/lib/rustdesk/rustdesk $out/bin/rustdesk \
      --chdir "$out/share"

    cp -a $src/src/ui $out/share/src

    install -Dm0644 $src/res/logo.svg $out/share/icons/hicolor/scalable/apps/rustdesk.svg
  '';

  postFixup = lib.optionalString stdenv.hostPlatform.isLinux ''
    patchelf --add-rpath "${libayatana-appindicator}/lib" "$out/lib/rustdesk/rustdesk"
  '';

  env = {
    SODIUM_USE_PKG_CONFIG = true;
    ZSTD_SYS_USE_PKG_CONFIG = true;
  };

  meta = {
    description = "Virtual / remote desktop infrastructure for everyone! Open source TeamViewer / Citrix alternative";
    homepage = "https://rustdesk.com";
    changelog = "https://github.com/rustdesk/rustdesk/releases/tag/${finalAttrs.version}";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [
      ocfox
      leixb
    ];
    mainProgram = "rustdesk";
    badPlatforms = lib.platforms.darwin;
  };
})

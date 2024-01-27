{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, wrapGAppsHook
, atk
, bzip2
, cairo
, dbus
, gdk-pixbuf
, glib
, gst_all_1
, gtk3
, libayatana-appindicator
, libgit2
, libpulseaudio
, libsodium
, libXtst
, libvpx
, libyuv
, libopus
, libaom
, libxkbcommon
, libsciter
, xdotool
, pam
, pango
, zlib
, zstd
, stdenv
, darwin
, alsa-lib
, makeDesktopItem
}:

rustPlatform.buildRustPackage rec {
  pname = "rustdesk";
  version = "1.2.3";

  src = fetchFromGitHub {
    owner = "rustdesk";
    repo = "rustdesk";
    rev = version;
    hash = "sha256-6TdirqEnWvuPgKOLzNIAm66EgKNdGVjD7vf2maqlxI8=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "confy-0.4.0-2" = "sha256-r5VeggXrIq5Cwxc2WSrxQDI5Gvbw979qIUQfMKHgBUI=";
      "evdev-0.11.5" = "sha256-aoPmjGi/PftnH6ClEWXHvIj0X3oh15ZC1q7wPC1XPr0=";
      "hwcodec-0.1.1" = "sha256-EQGJr5kH8O48y1oSrzFF3QGGpGFKP3v4gn2JquAkdlY=";
      "impersonate_system-0.1.0" = "sha256-qbaTw9gxMKDjX5pKdUrKlmIxCxWwb99YuWPDvD2A3kY=";
      "keepawake-0.4.3" = "sha256-sLQf9q88dB2bkTN01UlxRWSpoF1kFsqqpYC4Sw6cbEY=";
      "machine-uid-0.3.0" = "sha256-rEOyNThg6p5oqE9URnxSkPtzyW8D4zKzLi9pAnzTElE=";
      "magnum-opus-0.4.0" = "sha256-T4qaYOl8lCK1h9jWa9KqGvnVfDViT9Ob5R+YgnSw2tg=";
      "mouce-0.2.1" = "sha256-3PtNEmVMXgqKV4r3KiKTkk4oyCt4BKynniJREE+RyFk=";
      "pam-0.7.0" = "sha256-qe2GH6sfGEUnqLiQucYLB5rD/GyAaVtm9pAxWRb1H3Q=";
      "parity-tokio-ipc-0.7.3-2" = "sha256-WXDKcDBaJuq4K9gjzOKMozePOFiVX0EqYAFamAz/Yvw=";
      "rdev-0.5.0-2" = "sha256-MJ4Uqp0yz1CcFvoZYyUYwNojUcfW1AyVowKShihhhbY=";
      "reqwest-0.11.18" = "sha256-3k2wcVD+DzJEdP/+8BqP9qz3tgEWcbWZj5/CjrZz5LY=";
      "rust-pulsectl-0.2.12" = "sha256-8jXTspWvjONFcvw9/Z8C43g4BuGZ3rsG32tvLMQbtbM=";
      "sciter-rs-0.5.57" = "sha256-NQPDlMQ0sGY8c9lBMlplT82sNjbgJy2m/+REnF3fz8M=";
      "tao-0.22.2" = "sha256-vZx7WM6vK9UarbFQ/FMnTNEEDS+tglhWcPXt/h7YMFA=";
      "tfc-0.6.1" = "sha256-ukxJl7Z+pUXCjvTsG5Q0RiXocPERWGsnAyh3SIWm0HU=";
      "tokio-socks-0.5.1-2" = "sha256-x3aFJKo0XLaCGkZLtG9GYA+A/cGGedVZ8gOztWiYVUY=";
      "tray-icon-0.5.1" = "sha256-1VyUg8V4omgdRIYyXhfn8kUvhV5ef6D2cr2Djz2uQyc=";
      "x11-2.19.0" = "sha256-GDCeKzUtvaLeBDmPQdyr499EjEfT6y4diBMzZVEptzc=";
    };
  };

  desktopItems = [
    (makeDesktopItem {
      name = "rustdesk";
      exec = meta.mainProgram;
      icon = "rustdesk";
      desktopName = "RustDesk";
      comment = meta.description;
      genericName = "Remote Desktop";
      categories = [ "Network" ];
    })
  ];

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
    wrapGAppsHook
  ];

  buildFeatures = lib.optionals stdenv.isLinux [ "linux-pkg-config" ];

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
    xdotool
    pam
    pango
    zlib
    zstd
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.AppKit
    darwin.apple_sdk.frameworks.CoreAudio
    darwin.apple_sdk.frameworks.CoreFoundation
    darwin.apple_sdk.frameworks.CoreGraphics
    darwin.apple_sdk.frameworks.Foundation
    darwin.apple_sdk.frameworks.IOKit
    darwin.apple_sdk.frameworks.Security
    darwin.apple_sdk.frameworks.SystemConfiguration
  ] ++ lib.optionals stdenv.isLinux [
    alsa-lib
  ];

  # Add static ui resources and libsciter to same folder as binary so that it
  # can find them.
  postInstall = ''
    mkdir -p $out/{share/src,lib/rustdesk}

    # .so needs to be next to the executable
    mv $out/bin/rustdesk $out/lib/rustdesk
    ln -s ${libsciter}/lib/libsciter-gtk.so $out/lib/rustdesk

    makeWrapper $out/lib/rustdesk/rustdesk $out/bin/rustdesk \
      --chdir "$out/share"

    cp -a $src/src/ui $out/share/src

    install -Dm0644 $src/res/logo.svg $out/share/icons/hicolor/scalable/apps/rustdesk.svg
  '';

  postFixup = ''
    patchelf --add-rpath "${libayatana-appindicator}/lib" "$out/lib/rustdesk/rustdesk"
  '';

  env = {
    SODIUM_USE_PKG_CONFIG = true;
    ZSTD_SYS_USE_PKG_CONFIG = true;
  };

  meta = with lib; {
    description = "Virtual / remote desktop infrastructure for everyone! Open source TeamViewer / Citrix alternative";
    homepage = "https://rustdesk.com";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ ocfox leixb ];
    mainProgram = "rustdesk";
  };
}

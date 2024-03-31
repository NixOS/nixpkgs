{ lib
, clangStdenv
, cargo
, copyDesktopItems
, fetchFromGitHub
, flutter316
, gst_all_1
, libXtst
, libaom
, libopus
, libpulseaudio
, libva
, libvdpau
, libvpx
, libxkbcommon
, libyuv
, makeDesktopItem
, rustPlatform
, rustc
, rustfmt
, xdotool
}: let

  flutterRustBridge = rustPlatform.buildRustPackage rec {
    pname = "flutter_rust_bridge_codegen";
    version = "1.80.1"; # https://github.com/rustdesk/rustdesk/blob/16db977fd81e14af62ec5ac7760a7661a5c24be8/.github/workflows/bridge.yml#L10

    src = fetchFromGitHub {
      owner = "fzyzcjy";
      repo = "flutter_rust_bridge";
      rev = "v${version}";
      hash = "sha256-SbwqWapJbt6+RoqRKi+wkSH1D+Wz7JmnVbfcfKkjt8Q=";
    };

    cargoHash = "sha256-dDyiptG9TKes+fXx2atwx697SWH7Rltx6xVubtTn7FM=";
    cargoBuildFlags = [ "--package" "flutter_rust_bridge_codegen" ];
    doCheck = false;
  };

  sharedLibraryExt = rustc.stdenv.hostPlatform.extensions.sharedLibrary;

in flutter316.buildFlutterApplication rec {
  pname = "rustdesk";
  version = "1.2.3-unstable-2024-02-11";
  src = fetchFromGitHub {
    owner = "rustdesk";
    repo = "rustdesk";
    rev = "16db977fd81e14af62ec5ac7760a7661a5c24be8";
    hash = "sha256-k4gNuA/gZ58S0selOn9+K7+s5AQLkpz+DPI84Fuw414=";
  };

  strictDeps = true;

  # Configure the Flutter/Dart build
  sourceRoot = "${src.name}/flutter";
  # curl https://raw.githubusercontent.com/rustdesk/rustdesk/16db977fd81e14af62ec5ac7760a7661a5c24be8/flutter/pubspec.lock | yq
  pubspecLock = lib.importJSON ./pubspec.lock.json;
  gitHashes = {
    dash_chat_2 = "sha256-J5Bc6CeCoRGN870aNEVJ2dkQNb+LOIZetfG2Dsfz5Ow=";
    desktop_drop = "sha256-rt9N6TNAq7YRPzHSDVukGCXMvIIIj48HZaEJikbh6Pk=";
    desktop_multi_window = "sha256-jhhqV4srWd3oJwlKMHPpGvvdzyoH/kJtTg6AB4e9Udk=";
    dynamic_layouts = "sha256-eFp1YVI6vI2HRgtE5nTqGZIylB226H0O8kuxy9ypuf8=";
    flutter_improved_scrolling = "sha256-fKs1+JmhDVVfjyhr6Fl17pc6n++mCTjBo1PT3l/DUnc=";
    uni_links_desktop = "sha256-h3wlo31XnHELCCPlk7OSLglm9Xn/969yTllp5UkGY98=";
    window_manager = "sha256-CUTcSl+W7Wz/Og5k9ujOdAlhKWv/gIYe58wurf9CJH4=";
    window_size = "sha256-+lqY46ZURT0qcqPvHFXUnd83Uvfq79Xr+rw1AHqrpak=";
    flutter_gpu_texture_renderer = "sha256-w1iMp4wUDkG1UZCHFjUUL11GIHyUDUxM+ZM8l423MLk=";
  };

  # Configure the Rust build
  cargoRoot = "..";
  cargoDeps = rustPlatform.importCargoLock {
    # Upstream lock file after running `cargo generate-lockfile --offline` and
    # removing the git variant of core-foundation-sys
    lockFile = ./Cargo.lock;
    outputHashes = {
      "amf-0.1.0" = "sha256-j9w3bB1Nd8GuHyMHxjcTGBy3JJ26g/GiBg2OQgrdqLw=";
      "android-wakelock-0.1.0" = "sha256-09EH/U1BBs3l4galQOrTKmPUYBgryUjfc/rqPZhdYc4=";
      "cacao-0.4.0-beta2" = "sha256-U5tCLeVxjmZCm7ti1u71+i116xmozPaR69pCsA4pxrM=";
      "confy-0.4.0-2" = "sha256-r5VeggXrIq5Cwxc2WSrxQDI5Gvbw979qIUQfMKHgBUI=";
      "core-foundation-0.9.3" = "sha256-iB4OVmWZhuWbs9RFWvNc+RNut6rip2/50o5ZM6c0c3g=";
      "evdev-0.11.5" = "sha256-aoPmjGi/PftnH6ClEWXHvIj0X3oh15ZC1q7wPC1XPr0=";
      "hwcodec-0.2.0" = "sha256-yw3cmC74u6oLfJD6ouqACUZynHRujT/KJMtLOtzg7f4=";
      "impersonate_system-0.1.0" = "sha256-pIV7s2qGoCIUrhaRovBDCJaGQ/pMdJacDXJmeBpkcyI=";
      "keepawake-0.4.3" = "sha256-wDLjjhKWbCeaWbA896a5E5UMB0B/xI/84QRCUYNKX7I=";
      "machine-uid-0.3.0" = "sha256-rEOyNThg6p5oqE9URnxSkPtzyW8D4zKzLi9pAnzTElE=";
      "magnum-opus-0.4.0" = "sha256-T4qaYOl8lCK1h9jWa9KqGvnVfDViT9Ob5R+YgnSw2tg=";
      "mouce-0.2.1" = "sha256-3PtNEmVMXgqKV4r3KiKTkk4oyCt4BKynniJREE+RyFk=";
      "pam-0.7.0" = "sha256-qe2GH6sfGEUnqLiQucYLB5rD/GyAaVtm9pAxWRb1H3Q=";
      "parity-tokio-ipc-0.7.3-2" = "sha256-WXDKcDBaJuq4K9gjzOKMozePOFiVX0EqYAFamAz/Yvw=";
      "rdev-0.5.0-2" = "sha256-KrzNa4sKyuVw3EV/Ec9VBNRyJy7QFR2Gu4c2WkltwUw=";
      "reqwest-0.11.23" = "sha256-kEUT+gs4ziknDiGdPMLnj5pmxC5SBpLopZ8jZ34GDWc=";
      "rust-pulsectl-0.2.12" = "sha256-8jXTspWvjONFcvw9/Z8C43g4BuGZ3rsG32tvLMQbtbM=";
      "sciter-rs-0.5.57" = "sha256-NQPDlMQ0sGY8c9lBMlplT82sNjbgJy2m/+REnF3fz8M=";
      "sysinfo-0.29.10" = "sha256-O2zJGQdtXNiIwatmyIB6bu5eVyv1JS/IHkv//BDCpcY=";
      "tao-0.22.2" = "sha256-vZx7WM6vK9UarbFQ/FMnTNEEDS+tglhWcPXt/h7YMFA=";
      "tfc-0.6.1" = "sha256-ukxJl7Z+pUXCjvTsG5Q0RiXocPERWGsnAyh3SIWm0HU=";
      "tokio-socks-0.5.1-2" = "sha256-x3aFJKo0XLaCGkZLtG9GYA+A/cGGedVZ8gOztWiYVUY=";
      "tray-icon-0.5.1" = "sha256-1VyUg8V4omgdRIYyXhfn8kUvhV5ef6D2cr2Djz2uQyc=";
      "wallpaper-3.2.0" = "sha256-p9NRmusdA0wvF6onp1UTL0/4t7XnEAc19sqyGDnfg/Q=";
      "webm-1.1.0" = "sha256-p4BMej7yvb8c/dJynRWZmwo2hxAAY96Qx6Qx2DbT8hE=";
      "x11-2.19.0" = "sha256-GDCeKzUtvaLeBDmPQdyr499EjEfT6y4diBMzZVEptzc=";
      "x11-clipboard-0.8.1" = "sha256-PtqmSD2MwkbLVWbfTSXZW3WEvEnUlo04qieUTjN2whE=";
    };
  };
  dontCargoBuild = true;
  cargoBuildFlags = "--lib";
  cargoBuildType = "release";
  cargoBuildFeatures = [
    "linux-pkg-config"
    "hwcodec"
    "flutter"
    "flutter_texture_render"
  ];

  nativeBuildInputs = [
    # flutter_rust_bridge_codegen
    cargo
    copyDesktopItems
    rustfmt
    # Rust
    rustPlatform.cargoSetupHook
    rustPlatform.cargoBuildHook
    rustPlatform.bindgenHook
  ];

  buildInputs = [
    gst_all_1.gst-plugins-base
    gst_all_1.gstreamer
    libXtst
    libaom
    libopus
    libpulseaudio
    libva
    libvdpau
    libvpx
    libxkbcommon
    libyuv
    xdotool
  ];

  prePatch = ''
    chmod -R +w ..
  '';
  patchFlags = [ "-p1" "-d" ".." ];

  postPatch = ''
    substituteInPlace ../Cargo.toml --replace ", \"staticlib\", \"rlib\"" ""
    # The supplied Cargo.lock doesn't work with our fetcher so copy over the fixed version
    cp ${./Cargo.lock} ../Cargo.lock
    chmod +w ../Cargo.lock
  '';

  preBuild = ''
    # Build the Flutter/Rust bridge bindings
    cat <<EOF > bridge.yml
    rust_input:
      - "../src/flutter_ffi.rs"
    dart_output:
      - "./lib/generated_bridge.dart"
    llvm_path:
      - "${lib.getLib clangStdenv.cc.cc}"
    dart_format_line_length: 80
    llvm_compiler_opts: "-I ${lib.getLib clangStdenv.cc.cc}/lib/clang/${lib.versions.major clangStdenv.cc.version}/include -I ${clangStdenv.cc.libc_dev}/include"
    EOF
    RUST_LOG=info ${flutterRustBridge}/bin/flutter_rust_bridge_codegen bridge.yml

    # Build the Rust shared library
    cd ..
    preBuild=() # prevent loops
    cargoBuildHook
    mv ./target/*/release/liblibrustdesk${sharedLibraryExt} ./target/release/liblibrustdesk${sharedLibraryExt}
    cd flutter
  '';

  postInstall = ''
    mkdir -p $out/share/polkit-1/actions $out/share/icons/hicolor/{256x256,scalable}/apps
    cp ../res/128x128@2x.png $out/share/icons/hicolor/256x256/apps/rustdesk.png
    cp ../res/scalable.svg $out/share/icons/hicolor/scalable/apps/rustdesk.svg
    cp ../res/com.rustdesk.RustDesk.policy $out/share/polkit-1/actions/
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "rustdesk";
      desktopName = "RustDesk";
      genericName = "Remote Desktop";
      comment = "Remote Desktop";
      exec = "rustdesk %u";
      icon = "rustdesk";
      terminal = false;
      type = "Application";
      startupNotify = true;
      categories = [ "Network" "RemoteAccess" "GTK" ];
      keywords = [ "internet" ];
      actions.new-window = {
        name = "Open a New Window";
        exec = "rustdesk %u";
      };
    })
    (makeDesktopItem {
      name = "rustdesk-link";
      desktopName = "RustDeskURL Scheme Handler";
      noDisplay = true;
      mimeTypes = [ "x-scheme-handler/rustdesk" ];
      tryExec = "rustdesk";
      exec = "rustdesk %u";
      icon = "rustdesk";
      terminal = false;
      type = "Application";
      startupNotify = false;
    })
  ];

  meta = with lib; {
    description = "Virtual / remote desktop infrastructure for everyone! Open source TeamViewer / Citrix alternative";
    homepage = "https://rustdesk.com";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ das_j ];
    mainProgram = "rustdesk";
    platforms = platforms.linux; # should work on darwin as well but I have no machine to test with
  };
}

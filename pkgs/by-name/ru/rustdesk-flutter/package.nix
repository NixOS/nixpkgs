{
  lib,
  clangStdenv,
  cargo,
  copyDesktopItems,
  fetchFromGitHub,
  flutter316,
  ffmpeg,
  gst_all_1,
  fuse3,
  libXtst,
  libaom,
  libopus,
  libpulseaudio,
  libva,
  libvdpau,
  libvpx,
  libxkbcommon,
  libyuv,
  pam,
  makeDesktopItem,
  rustPlatform,
  rustc,
  rustfmt,
  xdotool,
}:
let

  flutterRustBridge = rustPlatform.buildRustPackage rec {
    pname = "flutter_rust_bridge_codegen";
    version = "1.80.1"; # https://github.com/rustdesk/rustdesk/blob/1.3.0/.github/workflows/bridge.yml#L10

    src = fetchFromGitHub {
      owner = "fzyzcjy";
      repo = "flutter_rust_bridge";
      rev = "v${version}";
      hash = "sha256-SbwqWapJbt6+RoqRKi+wkSH1D+Wz7JmnVbfcfKkjt8Q=";
    };

    cargoHash = "sha256-dDyiptG9TKes+fXx2atwx697SWH7Rltx6xVubtTn7FM=";
    cargoBuildFlags = [
      "--package"
      "flutter_rust_bridge_codegen"
    ];
    doCheck = false;
  };

  sharedLibraryExt = rustc.stdenv.hostPlatform.extensions.sharedLibrary;

in
flutter316.buildFlutterApplication rec {
  pname = "rustdesk";
  version = "1.3.0";
  src = fetchFromGitHub {
    owner = "rustdesk";
    repo = "rustdesk";
    rev = version;
    hash = "sha256-pDGURsF0eft2BkuXOzaMtNCHp9VFgZZh4bbNRa5NDII=";
  };

  strictDeps = true;
  env.VCPKG_ROOT = "/homeless-shelter"; # idk man, makes the build go since https://github.com/21pages/hwcodec/commit/1873c34e3da070a462540f61c0b782b7ab15dc84

  # Configure the Flutter/Dart build
  sourceRoot = "${src.name}/flutter";
  # curl https://raw.githubusercontent.com/rustdesk/rustdesk/1.3.0/flutter/pubspec.lock | yq > pubspec.lock.json
  pubspecLock = lib.importJSON ./pubspec.lock.json;
  gitHashes = {
    dash_chat_2 = "sha256-J5Bc6CeCoRGN870aNEVJ2dkQNb+LOIZetfG2Dsfz5Ow=";
    desktop_multi_window = "sha256-6nbOUmGTmJQx3Dr4MI6cKWwB1jEgUFUeHx24gpCkWY0=";
    dynamic_layouts = "sha256-eFp1YVI6vI2HRgtE5nTqGZIylB226H0O8kuxy9ypuf8=";
    flutter_gpu_texture_renderer = "sha256-0znIHlZ0ashRTev2kAXU179eq/V1RJC9Hp4jAfiPh5Q=";
    flutter_improved_scrolling = "sha256-fKs1+JmhDVVfjyhr6Fl17pc6n++mCTjBo1PT3l/DUnc=";
    window_manager = "sha256-CUTcSl+W7Wz/Og5k9ujOdAlhKWv/gIYe58wurf9CJH4=";
    window_size = "sha256-+lqY46ZURT0qcqPvHFXUnd83Uvfq79Xr+rw1AHqrpak=";
  };

  # Configure the Rust build
  cargoRoot = "..";
  cargoDeps = rustPlatform.importCargoLock {
    # Upstream lock file after removing the registry variant of core-foundation-sys
    # and fixing the resulting errors by removing the other registry deps.
    lockFile = ./Cargo.lock;
    outputHashes = {
      "android-wakelock-0.1.0" = "sha256-09EH/U1BBs3l4galQOrTKmPUYBgryUjfc/rqPZhdYc4=";
      "arboard-3.4.0" = "sha256-lZIG5z115ExR6DcUut1rk9MrYFzSyCYH9kNGIikOPJM=";
      "cacao-0.4.0-beta2" = "sha256-U5tCLeVxjmZCm7ti1u71+i116xmozPaR69pCsA4pxrM=";
      "clipboard-master-4.0.0-beta.6" = "sha256-GZyzGMQOZ0iwGNZa/ZzFp8gU2tQVWZBpAbim8yb6yZA=";
      "confy-0.4.0-2" = "sha256-V7BCKISrkJIxWC3WT5+B5Vav86YTQvdO9TO6A++47FU=";
      "core-foundation-0.9.3" = "sha256-iB4OVmWZhuWbs9RFWvNc+RNut6rip2/50o5ZM6c0c3g=";
      "evdev-0.11.5" = "sha256-aoPmjGi/PftnH6ClEWXHvIj0X3oh15ZC1q7wPC1XPr0=";
      "hwcodec-0.7.0" = "sha256-pfzcaD7h/U5ou+P7qRLR56iXOkm043rF74y+Q0FsVLo=";
      "impersonate_system-0.1.0" = "sha256-pIV7s2qGoCIUrhaRovBDCJaGQ/pMdJacDXJmeBpkcyI=";
      "keepawake-0.4.3" = "sha256-cqSpkq/PCz+5+ZUyPy5hF6rP3fBzuZDywyxMUQ50Rk4=";
      "machine-uid-0.3.0" = "sha256-rEOyNThg6p5oqE9URnxSkPtzyW8D4zKzLi9pAnzTElE=";
      "magnum-opus-0.4.0" = "sha256-T4qaYOl8lCK1h9jWa9KqGvnVfDViT9Ob5R+YgnSw2tg=";
      "pam-0.7.0" = "sha256-o47tVoFlW9RiL7O8Lvuwz7rMYQHO+5TG27XxkAdHEOE=";
      "pam-sys-1.0.0-alpha4" = "sha256-5HIErVWnanLo5054NgU+DEKC2wwyiJ8AHvbx0BGbyWo=";
      "parity-tokio-ipc-0.7.3-4" = "sha256-PKw2Twd2ap+tRrQxqg8T1FvpoeKn0hvBqn1Z44F1LcY=";
      "rdev-0.5.0-2" = "sha256-KrzNa4sKyuVw3EV/Ec9VBNRyJy7QFR2Gu4c2WkltwUw=";
      "reqwest-0.11.23" = "sha256-kEUT+gs4ziknDiGdPMLnj5pmxC5SBpLopZ8jZ34GDWc=";
      "rust-pulsectl-0.2.12" = "sha256-8jXTspWvjONFcvw9/Z8C43g4BuGZ3rsG32tvLMQbtbM=";
      "sciter-rs-0.5.57" = "sha256-5Nd9npdx8yQJEczHv7WmSmrE1lBfvp5z7BubTbYBg3E=";
      "sysinfo-0.29.10" = "sha256-/UsFAvlWs/F7X1xT+97Fx+pnpCguoPHU3hTynqYMEs4=";
      "tao-0.25.0" = "sha256-kLmx1z9Ybn/hDt2OcszEjtZytQIE+NKTIn9zNr9oEQk=";
      "tfc-0.7.0" = "sha256-4plK8ttbHsBPat3/rS+4RhGzirq2Ked2wrU8cQEU1zo=";
      "tokio-socks-0.5.2-1" = "sha256-i1dfNatqN4dinMcyAdLhj9hJWVsT10OWpCXsxl7pifI=";
      "tray-icon-0.14.3" = "sha256-dSX7LucZaLplRrh6zLwmFzyZN4ZtwIXzAEdZzlu3gQg=";
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
    "flutter"
    "hwcodec"
    "linux-pkg-config"
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
    ffmpeg
    fuse3
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
    pam
    xdotool
  ];

  prePatch = ''
    chmod -R +w ..
  '';
  patchFlags = [
    "-p1"
    "-d"
    ".."
  ];

  patches = [ ./make-build-reproducible.patch ];

  postPatch = ''
    substituteInPlace ../Cargo.toml --replace-fail ", \"staticlib\", \"rlib\"" ""
    # The supplied Cargo.lock doesn't work with our fetcher so copy over the fixed version
    cp ${./Cargo.lock} ../Cargo.lock
    chmod +w ../Cargo.lock
  '';

  preBuild = ''
    # Disable static linking of ffmpeg since https://github.com/21pages/hwcodec/commit/1873c34e3da070a462540f61c0b782b7ab15dc84¶
    sed -i 's/static=//g' /build/cargo-vendor-dir/hwcodec-*/build.rs

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
      categories = [
        "Network"
        "RemoteAccess"
        "GTK"
      ];
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

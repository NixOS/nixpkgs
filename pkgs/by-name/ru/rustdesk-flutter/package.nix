{
  lib,
  clangStdenv,
  cargo,
  copyDesktopItems,
  fetchFromGitHub,
  flutter,
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
  libayatana-appindicator,
  rustc,
  rustfmt,
  xdotool,
  xdg-user-dirs,
  pipewire,
  cargo-expand,
  yq,
  callPackage,
  addDriverRunpath,
}:
let
  flutterRustBridge = rustPlatform.buildRustPackage rec {
    pname = "flutter_rust_bridge_codegen";
    version = "1.80.1"; # https://github.com/rustdesk/rustdesk/blob/1.4.1/.github/workflows/bridge.yml#L10

    src = fetchFromGitHub {
      owner = "fzyzcjy";
      repo = "flutter_rust_bridge";
      rev = "v${version}";
      hash = "sha256-SbwqWapJbt6+RoqRKi+wkSH1D+Wz7JmnVbfcfKkjt8Q=";
    };

    patches = [
      ./update-flutter-dev-path.patch
    ];

    cargoHash = "sha256-4khuq/DK4sP98AMHyr/lEo1OJdqLujOIi8IgbKBY60Y=";
    cargoBuildFlags = [
      "--package"
      "flutter_rust_bridge_codegen"
    ];
    doCheck = false;
  };

  ffigen = callPackage ./ffigen {
    inherit flutter;
  };

  sharedLibraryExt = rustc.stdenv.hostPlatform.extensions.sharedLibrary;

in
flutter.buildFlutterApplication rec {
  pname = "rustdesk";
  version = "1.4.1";

  src = fetchFromGitHub {
    owner = "rustdesk";
    repo = "rustdesk";
    tag = version;
    fetchSubmodules = true;
    hash = "sha256-nS8KjLzgdzgvn5mM1lJL2vFk0g/ZUZBvdkjyC+MdHDE=";
  };

  strictDeps = true;
  env.VCPKG_ROOT = "/homeless-shelter"; # idk man, makes the build go since https://github.com/21pages/hwcodec/commit/1873c34e3da070a462540f61c0b782b7ab15dc84

  # Configure the Flutter/Dart build
  sourceRoot = "${src.name}/flutter";
  # curl https://raw.githubusercontent.com/rustdesk/rustdesk/1.4.1/flutter/pubspec.lock | yq > pubspec.lock.json
  pubspecLock = lib.importJSON ./pubspec.lock.json;
  gitHashes = {
    dash_chat_2 = "sha256-J5Bc6CeCoRGN870aNEVJ2dkQNb+LOIZetfG2Dsfz5Ow=";
    desktop_multi_window = "sha256-NOe0jMcH02c0TDTtv62OMTR/qDPnRQrRe73vXDuEq8Q=";
    dynamic_layouts = "sha256-eFp1YVI6vI2HRgtE5nTqGZIylB226H0O8kuxy9ypuf8=";
    flutter_gpu_texture_renderer = "sha256-EZa1FOMbcwdVs/m0vsUvlHv+MifPby4I97ZFe1bqmwQ=";
    window_manager = "sha256-40mwj4D8W2xW8C7RshTjOhelOiLPM7uU9rsF4NvQn8c=";
    window_size = "sha256-XelNtp7tpZ91QCEcvewVphNUtgQX7xrp5QP0oFo6DgM=";
    texture_rgba_renderer = "sha256-V/bmT/5x+Bt7kdjLTkgkoXdBcFVXxPyp9kIUhf+Rnt4=";
    uni_links = "sha256-O2BgNwu5HFRQyaNkskWHORx8pZhdwEjtljvw1+zFzfo=";
  };

  # Configure the Rust build
  cargoRoot = "..";
  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit
      pname
      version
      src
      patches
      ;
    hash = "sha256-ecLR6cMVDrTKeoTE5Yxkw5dN4ceAm+RD7BVXwIQ1fnk=";
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
    cargo-expand
    rustPlatform.bindgenHook
    ffigen
    yq
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
    pipewire
    libxkbcommon
    libyuv
    pam
    xdotool
  ];

  prePatch = ''
    chmod -R +w ..
    cd ..
  '';

  patches = [
    ./make-build-reproducible.patch
  ];

  prepareBuildRunner = ''
    cp ${./build-runner.sh} build_runner
    substituteInPlace build_runner \
      --replace-fail "@bash@" "$SHELL"
    chmod +x build_runner
    export PATH=$PATH:$PWD
  '';

  postPatch = ''
    cd flutter
    if [ $cargoDepsCopy ]; then # That will be inherited to buildDartPackage and it doesn't have cargoDepsCopy
      substituteInPlace $cargoDepsCopy/libappindicator-sys-*/src/lib.rs \
        --replace-fail "libayatana-appindicator3.so.1" "${lib.getLib libayatana-appindicator}/lib/libayatana-appindicator3.so.1"
      # Disable static linking of ffmpeg since https://github.com/21pages/hwcodec/commit/1873c34e3da070a462540f61c0b782b7ab15dc84
      sed -i 's/static=//g' $cargoDepsCopy/hwcodec-*/build.rs
    fi

    substituteInPlace ../Cargo.toml --replace-fail ", \"staticlib\", \"rlib\"" ""
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
    runHook prepareBuildRunner
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
  '';

  extraWrapProgramArgs = ''
    --prefix LD_LIBRARY_PATH : ${addDriverRunpath.driverLink}/lib \
    --prefix PATH : ${lib.makeBinPath [ xdg-user-dirs ]}
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

  meta = {
    description = "Virtual / remote desktop infrastructure for everyone! Open source TeamViewer / Citrix alternative";
    homepage = "https://rustdesk.com";
    changelog = "https://github.com/rustdesk/rustdesk/releases/${version}";
    license = lib.licenses.agpl3Only;
    teams = [ lib.teams.helsinki-systems ];
    mainProgram = "rustdesk";
    platforms = lib.platforms.linux; # should work on darwin as well but I have no machine to test with
  };
}

{ stdenv
, rustPlatform
, lib
, fetchFromGitHub
, ncurses
, perl
, pkg-config
, python3
, fontconfig
, installShellFiles
, openssl
, libGL
, libX11
, libxcb
, libxkbcommon
, xcbutil
, xcbutilimage
, xcbutilkeysyms
, xcbutilwm
, wayland
, zlib
, CoreGraphics
, Cocoa
, Foundation
, System
, libiconv
, UserNotifications
, nixosTests
, runCommand
, vulkan-loader
}:

rustPlatform.buildRustPackage rec {
  pname = "wezterm";
  version = "20230712-072601-f4abf8fd";

  src = fetchFromGitHub {
    owner = "wez";
    repo = pname;
    rev = version;
    fetchSubmodules = true;
    hash = "sha256-B6AakLbTWIN123qAMQk/vFN83HHNRSNkqicNRU1GaCc=";
  };

  postPatch = ''
    echo ${version} > .tag

    # tests are failing with: Unable to exchange encryption keys
    rm -r wezterm-ssh/tests
  '';

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "image-0.24.5" = "sha256-fTajVwm88OInqCPZerWcSAm1ga46ansQ3EzAmbT58Js=";
      "xcb-1.2.1" = "sha256-zkuW5ATix3WXBAj2hzum1MJ5JTX3+uVQ01R1vL6F1rY=";
      "xcb-imdkit-0.2.0" = "sha256-L+NKD0rsCk9bFABQF4FZi9YoqBHr4VAZeKAWgsaAegw=";
    };
  };

  nativeBuildInputs = [
    installShellFiles
    ncurses # tic for terminfo
    pkg-config
    python3
  ] ++ lib.optional stdenv.isDarwin perl;

  buildInputs = [
    fontconfig
    zlib
  ] ++ lib.optionals stdenv.isLinux [
    libX11
    libxcb
    libxkbcommon
    openssl
    wayland
    xcbutil
    xcbutilimage
    xcbutilkeysyms
    xcbutilwm # contains xcb-ewmh among others
  ] ++ lib.optionals stdenv.isDarwin [
    Cocoa
    CoreGraphics
    Foundation
    libiconv
    System
    UserNotifications
  ];

  buildFeatures = [ "distro-defaults" ];

  env.NIX_LDFLAGS = lib.optionalString stdenv.isDarwin "-framework System";

  postInstall = ''
    mkdir -p $out/nix-support
    echo "${passthru.terminfo}" >> $out/nix-support/propagated-user-env-packages

    install -Dm644 assets/icon/terminal.png $out/share/icons/hicolor/128x128/apps/org.wezfurlong.wezterm.png
    install -Dm644 assets/wezterm.desktop $out/share/applications/org.wezfurlong.wezterm.desktop
    install -Dm644 assets/wezterm.appdata.xml $out/share/metainfo/org.wezfurlong.wezterm.appdata.xml

    install -Dm644 assets/shell-integration/wezterm.sh -t $out/etc/profile.d
    installShellCompletion --cmd wezterm \
      --bash assets/shell-completion/bash \
      --fish assets/shell-completion/fish \
      --zsh assets/shell-completion/zsh

    install -Dm644 assets/wezterm-nautilus.py -t $out/share/nautilus-python/extensions
  '';

  preFixup = lib.optionalString stdenv.isLinux ''
    patchelf \
      --add-needed "${libGL}/lib/libEGL.so.1" \
      --add-needed "${vulkan-loader}/lib/libvulkan.so.1" \
      $out/bin/wezterm-gui
  '' + lib.optionalString stdenv.isDarwin ''
    mkdir -p "$out/Applications"
    OUT_APP="$out/Applications/WezTerm.app"
    cp -r assets/macos/WezTerm.app "$OUT_APP"
    rm $OUT_APP/*.dylib
    cp -r assets/shell-integration/* "$OUT_APP"
    ln -s $out/bin/{wezterm,wezterm-mux-server,wezterm-gui,strip-ansi-escapes} "$OUT_APP"
  '';

  passthru = {
    tests = {
      all-terminfo = nixosTests.allTerminfo;
      terminal-emulators = nixosTests.terminal-emulators.wezterm;
    };
    terminfo = runCommand "wezterm-terminfo"
      {
        nativeBuildInputs = [ ncurses ];
      } ''
      mkdir -p $out/share/terminfo $out/nix-support
      tic -x -o $out/share/terminfo ${src}/termwiz/data/wezterm.terminfo
    '';
  };

  meta = with lib; {
    description = "GPU-accelerated cross-platform terminal emulator and multiplexer written by @wez and implemented in Rust";
    homepage = "https://wezfurlong.org/wezterm";
    license = licenses.mit;
    mainProgram = "wezterm";
    maintainers = with maintainers; [ SuperSandro2000 mimame ];
  };
}

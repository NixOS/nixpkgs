{
  stdenv,
  rustPlatform,
  lib,
  fetchFromGitHub,
  ncurses,
  perl,
  pkg-config,
  python3,
  fontconfig,
  installShellFiles,
  openssl,
  libGL,
  libX11,
  libxcb,
  libxkbcommon,
  xcbutil,
  xcbutilimage,
  xcbutilkeysyms,
  xcbutilwm,
  wayland,
  zlib,
  CoreGraphics,
  Cocoa,
  Foundation,
  System,
  libiconv,
  UserNotifications,
  nixosTests,
  runCommand,
  vulkan-loader,
}:

rustPlatform.buildRustPackage rec {
  pname = "wezterm";
  version = "20240203-110809-5046fc22";

  src = fetchFromGitHub {
    owner = "wez";
    repo = "wezterm";
    rev = version;
    fetchSubmodules = true;
    hash = "sha256-Az+HlnK/lRJpUSGm5UKyma1l2PaBKNCGFiaYnLECMX8=";
  };

  postPatch = ''
    cp ${./Cargo.lock} Cargo.lock

    echo ${version} > .tag

    # tests are failing with: Unable to exchange encryption keys
    rm -r wezterm-ssh/tests

    # hash does not work well with NixOS
    substituteInPlace assets/shell-integration/wezterm.sh \
      --replace-fail 'hash wezterm 2>/dev/null' 'command type -P wezterm &>/dev/null' \
      --replace-fail 'hash base64 2>/dev/null' 'command type -P base64 &>/dev/null' \
      --replace-fail 'hash hostname 2>/dev/null' 'command type -P hostname &>/dev/null' \
      --replace-fail 'hash hostnamectl 2>/dev/null' 'command type -P hostnamectl &>/dev/null'
  '';

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "xcb-imdkit-0.3.0" = "sha256-fTpJ6uNhjmCWv7dZqVgYuS2Uic36XNYTbqlaly5QBjI=";
    };
  };

  nativeBuildInputs = [
    installShellFiles
    ncurses # tic for terminfo
    pkg-config
    python3
  ] ++ lib.optional stdenv.hostPlatform.isDarwin perl;

  buildInputs =
    [
      fontconfig
      zlib
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      libX11
      libxcb
      libxkbcommon
      openssl
      wayland
      xcbutil
      xcbutilimage
      xcbutilkeysyms
      xcbutilwm # contains xcb-ewmh among others
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      Cocoa
      CoreGraphics
      Foundation
      libiconv
      System
      UserNotifications
    ];

  buildFeatures = [ "distro-defaults" ];

  env.NIX_LDFLAGS = lib.optionalString stdenv.hostPlatform.isDarwin "-framework System";

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

  preFixup =
    lib.optionalString stdenv.hostPlatform.isLinux ''
      patchelf \
        --add-needed "${libGL}/lib/libEGL.so.1" \
        --add-needed "${vulkan-loader}/lib/libvulkan.so.1" \
        $out/bin/wezterm-gui
    ''
    + lib.optionalString stdenv.hostPlatform.isDarwin ''
      mkdir -p "$out/Applications"
      OUT_APP="$out/Applications/WezTerm.app"
      cp -r assets/macos/WezTerm.app "$OUT_APP"
      rm $OUT_APP/*.dylib
      cp -r assets/shell-integration/* "$OUT_APP"
      ln -s $out/bin/{wezterm,wezterm-mux-server,wezterm-gui,strip-ansi-escapes} "$OUT_APP"
    '';

  passthru = {
    # the headless variant is useful when deploying wezterm's mux server on remote severs
    headless = rustPlatform.buildRustPackage {
      pname = "${pname}-headless";
      inherit
        version
        src
        postPatch
        cargoLock
        meta
        ;

      nativeBuildInputs = [ pkg-config ];

      buildInputs = [ openssl ];

      cargoBuildFlags = [
        "--package"
        "wezterm"
        "--package"
        "wezterm-mux-server"
      ];

      doCheck = false;

      postInstall = ''
        install -Dm644 assets/shell-integration/wezterm.sh -t $out/etc/profile.d
        install -Dm644 ${passthru.terminfo}/share/terminfo/w/wezterm -t $out/share/terminfo/w
      '';
    };

    terminfo =
      runCommand "wezterm-terminfo"
        {
          nativeBuildInputs = [ ncurses ];
        }
        ''
          mkdir -p $out/share/terminfo $out/nix-support
          tic -x -o $out/share/terminfo ${src}/termwiz/data/wezterm.terminfo
        '';

    tests = {
      all-terminfo = nixosTests.allTerminfo;
      # the test is commented out in nixos/tests/terminal-emulators.nix
      #terminal-emulators = nixosTests.terminal-emulators.wezterm;
    };
  };

  meta = with lib; {
    description = "GPU-accelerated cross-platform terminal emulator and multiplexer written by @wez and implemented in Rust";
    homepage = "https://wezfurlong.org/wezterm";
    license = licenses.mit;
    mainProgram = "wezterm";
    maintainers = with maintainers; [
      SuperSandro2000
      mimame
    ];
  };
}

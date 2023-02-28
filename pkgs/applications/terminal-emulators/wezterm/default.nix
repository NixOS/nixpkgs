{ stdenv
, rustPlatform
, lib
, fetchFromGitHub
, fetchpatch
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
, libiconv
, UserNotifications
, nixosTests
, runCommand
, vulkan-loader
}:

rustPlatform.buildRustPackage rec {
  pname = "wezterm";
  version = "20221119-145034-49b9839f";

  src = fetchFromGitHub {
    owner = "wez";
    repo = pname;
    rev = version;
    fetchSubmodules = true;
    sha256 = "sha256-1gnP2Dn4nkhxelUsXMay2VGvgvMjkdEKhFK5AAST++s=";
  };

  patches = [
    # fix build with rust 1.67
    (fetchpatch {
      url = "https://github.com/wez/wezterm/commit/36519f0d90e1875fb4b3f11f6cbf94c7d716ef78.patch";
      sha256 = "sha256-sOGFmDan1uO1xOBCpvlGrSotjfw01MjRg0KVqa5omig=";
    })
  ];

  postPatch = ''
    echo ${version} > .tag

    # tests are failing with: Unable to exchange encryption keys
    rm -r wezterm-ssh/tests
  '';

  cargoSha256 = "sha256-D6/biuLsXaCr0KSiopo9BuAVmniF8opAfDH71C3dtt0=";

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
    UserNotifications
  ];

  buildFeatures = [ "distro-defaults" ];

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
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}

{ stdenv
, rustPlatform
, lib
, fetchFromGitHub
, ncurses
, pkg-config
, fontconfig
, python3
, openssl
, perl
, dbus
, libX11
, xcbutil
, libxcb
, xcbutilimage
, xcbutilkeysyms
, xcbutilwm # contains xcb-ewmh among others
, libxkbcommon
, libglvnd # libEGL.so.1
, egl-wayland
, wayland
, libGLU
, libGL
, freetype
, zlib
  # Apple frameworks
, CoreGraphics
, Cocoa
, Foundation
, libiconv
}:
let
  runtimeDeps = [
    zlib
    fontconfig
    freetype
  ] ++ lib.optionals stdenv.isLinux [
    libX11
    xcbutil
    libxcb
    xcbutilimage
    xcbutilkeysyms
    xcbutilwm
    libxkbcommon
    dbus
    libglvnd
    egl-wayland
    wayland
    libGLU
    libGL
    openssl
  ] ++ lib.optionals stdenv.isDarwin [
    Foundation
    CoreGraphics
    Cocoa
    libiconv
  ];
in

rustPlatform.buildRustPackage rec {
  pname = "wezterm";
  version = "20210502-154244-3f7122cb";

  src = fetchFromGitHub {
    owner = "wez";
    repo = pname;
    rev = version;
    sha256 = "9HPhb7Vyy5DwBW1xeA6sEIBmmOXlky9lPShu6ZoixPw=";
    fetchSubmodules = true;
  };

  outputs = [ "out" "terminfo" ];

  postPatch = ''
    echo ${version} > .tag
  '';

  cargoSha256 = "sha256-cbZg2wc3G2ffMQBB6gd0vBbow5GRbXaj8Xh5ga1cMxU=";

  nativeBuildInputs = [
    pkg-config
    python3
    perl
    ncurses
  ];

  buildInputs = runtimeDeps;

  postInstall = ''
    # terminfo
    mkdir -p $terminfo/share/terminfo/w $out/nix-support
    tic -x -o $terminfo/share/terminfo termwiz/data/wezterm.terminfo
    echo "$terminfo" >> $out/nix-support/propagated-user-env-packages

    # desktop icon
    install -Dm644 assets/icon/terminal.png $out/share/icons/hicolor/128x128/apps/org.wezfurlong.wezterm.png
    install -Dm644 assets/wezterm.desktop $out/share/applications/org.wezfurlong.wezterm.desktop
    install -Dm644 assets/wezterm.appdata.xml $out/share/metainfo/org.wezfurlong.wezterm.appdata.xml

    # helper scripts
    install -Dm644 assets/shell-integration/wezterm.sh $out/share/wezterm/shell-integration/wezterm.sh
  '';

  preFixup = lib.optionalString stdenv.isLinux ''
    for artifact in wezterm wezterm-gui wezterm-mux-server strip-ansi-escapes; do
      patchelf --set-rpath "${lib.makeLibraryPath runtimeDeps}" $out/bin/$artifact
    done
  '' + lib.optionalString stdenv.isDarwin ''
    mkdir -p "$out/Applications"
    OUT_APP="$out/Applications/WezTerm.app"
    cp -r assets/macos/WezTerm.app "$OUT_APP"
    rm $OUT_APP/*.dylib
    cp -r assets/shell-integration/* "$OUT_APP"
    ln -s $out/bin/{wezterm,wezterm-mux-server,wezterm-gui,strip-ansi-escapes} "$OUT_APP"
  '';

  # prevent further changes to the RPATH
  dontPatchELF = true;

  meta = with lib; {
    description = "A GPU-accelerated cross-platform terminal emulator and multiplexer written by @wez and implemented in Rust";
    homepage = "https://wezfurlong.org/wezterm";
    license = licenses.mit;
    maintainers = with maintainers; [ steveej SuperSandro2000 ];
    platforms = platforms.unix;
  };
}

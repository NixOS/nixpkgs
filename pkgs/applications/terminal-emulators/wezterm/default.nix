{ stdenv
, rustPlatform
, lib
, fetchFromGitHub

, pkg-config
, fontconfig
, python3
, openssl
, perl

# Apple frameworks
, CoreGraphics
, Cocoa
, Foundation
, libiconv

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
}:
let
  runtimeDeps = [
    zlib
    fontconfig
    freetype
  ] ++ lib.optionals (stdenv.isLinux) [
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
  ] ++ lib.optionals (stdenv.isDarwin) [
    Foundation
    CoreGraphics
    Cocoa
    libiconv
  ];
  pname = "wezterm";
in

rustPlatform.buildRustPackage {
  inherit pname;
  version = "20210314";

  src = fetchFromGitHub {
    owner = "wez";
    repo = pname;
    rev = "20210314-114017-04b7cedd";
    sha256 = "sha256-EwoJLwOgoXtTEBbf/4pM+pCCG8fGkVruHVYh2HivCd0=";
    fetchSubmodules = true;
  };
  cargoSha256 = "sha256-OHbWgnlul9VfbPcMdzbuRJG59+myiukkzmnWohj5v2k=";

  nativeBuildInputs = [
    pkg-config
    python3
    openssl.dev
    perl
  ];

  buildInputs = runtimeDeps;

  preFixup = "" + lib.optionalString stdenv.isLinux ''
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
    maintainers = with maintainers; [ steveej ];
    platforms = platforms.unix;
  };
}

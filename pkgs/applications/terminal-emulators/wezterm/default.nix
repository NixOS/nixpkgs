{ stdenv
, rustPlatform
, lib
, fetchFromGitHub
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
    openssl
  ] ++ lib.optionals (stdenv.isDarwin) [
    Foundation
    CoreGraphics
    Cocoa
    libiconv
  ];
in

rustPlatform.buildRustPackage rec {
  pname = "wezterm";
  version = "20210407-nightly";

  src = fetchFromGitHub {
    owner = "wez";
    repo = pname;
    rev = "d2419fb99e567e3b260980694cc840a1a3b86922";
    sha256 = "4tVjrdDlrDPKzcbTYK9vRlzfC9tfvkD+D0aN19A8RWE=";
    fetchSubmodules = true;
  };

  postPatch = ''
    echo ${version} > .tag
  '';

  cargoSha256 = "sha256-UaXeeuRuQk+CWF936mEAaWTjZuTSRPmxbQ/9E2oZIqg=";

  nativeBuildInputs = [
    pkg-config
    python3
    perl
  ];

  buildInputs = runtimeDeps;

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

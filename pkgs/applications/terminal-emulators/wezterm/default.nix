{ rustPlatform
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
    libX11
    xcbutil
    libxcb
    xcbutilkeysyms
    xcbutilwm
    libxkbcommon
    dbus
    libglvnd
    zlib
    egl-wayland
    wayland
    libGLU
    libGL
    fontconfig
    freetype
  ];
  pname = "wezterm";
in

rustPlatform.buildRustPackage {
  inherit pname;
  version = "unstable-2020-11-22";

  src = fetchFromGitHub {
    owner = "wez";
    repo = pname;
    rev = "3bd8d8c84591f4d015ff9a47ddb478e55c231fda";
    sha256 = "13xf3685kir4p159hsxrqkj9p2lwgfp0n13h9zadslrd44l8b8j8";
    fetchSubmodules = true;
  };
  cargoSha256 = "1ghjpyd3f5dqi6bblr6d2lihdschpyj5djfd1600hvb41x75lmhx";

  nativeBuildInputs = [
    pkg-config
    python3
    openssl.dev
    perl
  ];

  buildInputs = runtimeDeps;

  installPhase = ''
    for artifact in wezterm wezterm-gui wezterm-mux-server strip-ansi-escapes; do
      patchelf --set-rpath "${lib.makeLibraryPath runtimeDeps}" $releaseDir/$artifact
      install -D $releaseDir/$artifact -t $out/bin
    done
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

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
  version = "2020-12-15";
  rev = "7e49377313cd2f9bc7e406ed6ad3216d883875f3";
in

rustPlatform.buildRustPackage {
  inherit pname;
  version = "unstable-2020-11-22";

  src = fetchFromGitHub {
    owner = "wez";
    repo = pname;
    inherit rev;
    fetchSubmodules = true;
    sha256 = "0p4krjc7k31k9qdc23g26rja9xqpm94dcv1vk7a73sr2dlfj06hn";
  };
  cargoSha256 = "0r6bgxx5qcbxy1qc3igvjp33in60ll45rsnbh2lc643a3pfkgrr6";

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
      install -Dsm755 $releaseDir/$artifact $out/bin/$artifact
    done

    install -Dm644 assets/shell-integration/* -t $out/etc/profile.d
    install -Dm644 assets/icon/terminal.png $out/usr/share/icons/hicolor/128x128/apps/org.wezfurlong.wezterm.png
    install -Dm644 assets/wezterm.desktop $out/usr/share/applications/org.wezfurlong.wezterm.desktop
    install -Dm644 assets/wezterm.appdata.xml $out/usr/share/metainfo/org.wezfurlong.wezterm.appdata.xml

    runHook postInstall
  '';

  # prevent further changes to the RPATH
  dontPatchELF = true;

  meta = with lib; {
    description = "A GPU-accelerated cross-platform terminal emulator and multiplexer written by @wez and implemented in Rust";
    homepage = "https://wezfurlong.org/wezterm";
    license = with licenses; [ bsd3 mit ofl ];
    maintainers = with maintainers; [ steveej ];
    platforms = platforms.unix;
  };
}

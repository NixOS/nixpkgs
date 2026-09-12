{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  systemd,
  freetype,
  harfbuzz,
  resvg,
  wayland,
  fontconfig,
  wayland-scanner,
  wayland-protocols,
  libxkbcommon,
}:
stdenv.mkDerivation rec {
  pname = "sw_swaybar";
  version = "0-unstable-2026-04-04";

  src = fetchFromGitHub {
    owner = "pd2s";
    repo = "sw";
    rev = "fe226c9de2c5034eb13aa0d76ecf73d81fabdec0";
    hash = "sha256-uWKJfJXVfUQrdThnBURloTLDQpn138wpIOHXKQg2E7c=";
  };

  sourceRoot = "${src.name}/examples/sw_swaybar";

  __structuredAttrs = true;
  strictDeps = true;

  nativeBuildInputs = [
    pkg-config
    wayland-scanner
  ];

  buildInputs = [
    systemd
    freetype
    harfbuzz
    resvg
    wayland
    fontconfig
    libxkbcommon
  ];

  NIX_CFLAGS_COMPILE = "-I${src} -I./include -I${fontconfig.dev}/include/fontconfig";
  NIX_LDFLAGS = "-lfreetype -lwayland-client -lresvg -lharfbuzz";

  postConfigure = ''
    mkdir -p include

    wayland-scanner private-code ${wayland-protocols}/share/wayland-protocols/stable/xdg-shell/xdg-shell.xml include/xdg-shell.c
    wayland-scanner private-code $src/wlr-layer-shell-unstable-v1.xml include/wlr-layer-shell-unstable-v1.c
    wayland-scanner private-code ${wayland-protocols}/share/wayland-protocols/unstable/tablet/tablet-unstable-v2.xml include/tablet-unstable-v2.c
    wayland-scanner private-code ${wayland-protocols}/share/wayland-protocols/staging/cursor-shape/cursor-shape-v1.xml include/cursor-shape-v1.c
    wayland-scanner private-code ${wayland-protocols}/share/wayland-protocols/unstable/xdg-decoration/xdg-decoration-unstable-v1.xml include/xdg-decoration-unstable-v1.c
    wayland-scanner client-header ${wayland-protocols}/share/wayland-protocols/stable/xdg-shell/xdg-shell.xml include/xdg-shell.h
    wayland-scanner client-header $src/wlr-layer-shell-unstable-v1.xml include/wlr-layer-shell-unstable-v1.h
    wayland-scanner client-header ${wayland-protocols}/share/wayland-protocols/staging/cursor-shape/cursor-shape-v1.xml include/cursor-shape-v1.h
    wayland-scanner client-header ${wayland-protocols}/share/wayland-protocols/unstable/xdg-decoration/xdg-decoration-unstable-v1.xml include/xdg-decoration-unstable-v1.h
  '';

  buildPhase = ''
    ./build.sh
  '';

  installPhase = ''
    mkdir -p $out/bin

    cp -ar sw_swaybar $out/bin
  '';

  meta = {
    description = "A nearly feature-compatible swaybar replacement with tray DBus Menu support";
    homepage = "https://github.com/pd2s/sw";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.corbinwunderlich ];
    mainProgram = "sw_swaybar";
  };
}

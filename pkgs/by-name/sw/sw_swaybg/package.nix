{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  resvg,
  wayland,
  wayland-scanner,
  wayland-protocols,
  libxkbcommon,
}:
stdenv.mkDerivation rec {
  pname = "sw_swaybg";
  version = "0-unstable-2026-04-04";

  src = fetchFromGitHub {
    owner = "pd2s";
    repo = "sw";
    rev = "fe226c9de2c5034eb13aa0d76ecf73d81fabdec0";
    hash = "sha256-uWKJfJXVfUQrdThnBURloTLDQpn138wpIOHXKQg2E7c=";
  };

  sourceRoot = "${src.name}/examples/sw_swaybg";

  __structuredAttrs = true;
  strictDeps = true;

  nativeBuildInputs = [
    pkg-config
    wayland-scanner
  ];

  buildInputs = [
    resvg
    wayland
    libxkbcommon
  ];

  NIX_CFLAGS_COMPILE = "-I${src} -I./include";
  NIX_LDFLAGS = "-lwayland-client -lresvg";

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

    cp -ar sw_swaybg $out/bin
  '';

  meta = {
    description = "A feature-compatible swaybg replacement with support for more image formats";
    homepage = "https://github.com/pd2s/sw";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.corbinwunderlich ];
    mainProgram = "sw_swaybg";
  };
}

{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  scdoc,
  wayland,
  wayland-protocols,
  cairo,
  gdk-pixbuf,
  gnome,
  webp-pixbuf-loader,
  wayland-scanner,
  wrapGAppsNoGuiHook,
  librsvg,
  libjxl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "swaybg";
  version = "1.2.2";

  src = fetchFromGitHub {
    owner = "swaywm";
    repo = "swaybg";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ByocNDqkv1ufN3Rr5yrfGkN5zS+Cw1e8QLQ+5opc1K4=";
  };

  strictDeps = true;
  depsBuildBuild = [ pkg-config ];
  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    scdoc
    wayland-scanner
    wrapGAppsNoGuiHook
    gdk-pixbuf
  ];
  buildInputs = [
    wayland
    wayland-protocols
    cairo
    gdk-pixbuf
    librsvg
  ];

  mesonFlags = [
    "-Dgdk-pixbuf=enabled"
    "-Dman-pages=enabled"
  ];

  # add support for webp
  postInstall = ''
    export GDK_PIXBUF_MODULE_FILE="${
      gnome._gdkPixbufCacheBuilder_DO_NOT_USE {
        extraLoaders = [
          librsvg
          webp-pixbuf-loader
          libjxl
        ];
      }
    }"
  '';

  meta = {
    description = "Wallpaper tool for Wayland compositors";
    inherit (finalAttrs.src.meta) homepage;
    longDescription = ''
      A wallpaper utility for Wayland compositors, that is compatible with any
      Wayland compositor which implements the following Wayland protocols:
      wlr-layer-shell, xdg-output, and xdg-shell.
    '';
    license = lib.licenses.mit;
    mainProgram = "swaybg";
    maintainers = with lib.maintainers; [
      ryan4yin
    ];
    platforms = lib.platforms.linux;
  };
})

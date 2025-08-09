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
}:

stdenv.mkDerivation rec {
  pname = "swaybg";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "swaywm";
    repo = "swaybg";
    tag = "v${version}";
    hash = "sha256-IJcPSBJErf8Dy9YhYAc9eg/llgaaLZCQSB0Brof+kpg=";
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
        ];
      }
    }"
  '';

  meta = with lib; {
    description = "Wallpaper tool for Wayland compositors";
    inherit (src.meta) homepage;
    longDescription = ''
      A wallpaper utility for Wayland compositors, that is compatible with any
      Wayland compositor which implements the following Wayland protocols:
      wlr-layer-shell, xdg-output, and xdg-shell.
    '';
    license = licenses.mit;
    mainProgram = "swaybg";
    maintainers = with maintainers; [
      ryan4yin
    ];
    platforms = platforms.linux;
  };
}

{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  blueprint-compiler,
  wrapGAppsHook4,
  gettext,
  desktop-file-utils,
  appstream,
  glib,
  glib-networking,
  pkg-config,
  gtk4,
  python3,
  python3Packages,
  libadwaita,
  gobject-introspection,
  libsecret,
  gst_all_1,
  xdg-user-dirs,
  gnome,
  librsvg,
  webp-pixbuf-loader,
  libavif,
  libheif,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "nocturne";
  version = "1.2.2";

  src = fetchFromGitHub {
    owner = "Jeffser";
    repo = "Nocturne";
    tag = finalAttrs.version;
    hash = "sha256-2UtlOdxXFdWoGeEwb89qI5Xp8FES2I3Eno8DIbhkBhI=";
  };

  __structuredAttrs = true;

  dontUseCmakeConfigure = true;

  strictDeps = true;
  nativeBuildInputs = [
    meson
    ninja
    blueprint-compiler
    gobject-introspection
    wrapGAppsHook4
    gettext # for msgfmt
    desktop-file-utils # for desktop-file-validate
    appstream
    glib
    pkg-config
    gtk4
    python3
  ];

  buildInputs = [
    gtk4
    libadwaita
    libsecret
    python3
    glib-networking
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-bad
  ];

  pythonDependencies = [
    python3Packages.pygobject3
    python3Packages.tinytag
    python3Packages.requests
    python3Packages.syncedlyrics
    python3Packages.pycairo
    python3Packages.colorthief
    python3Packages.mpris-server
    python3Packages.pillow
  ];

  preInstall = ''
    export GDK_PIXBUF_MODULE_FILE="${
      gnome._gdkPixbufCacheBuilder_DO_NOT_USE {
        extraLoaders = [
          librsvg
          webp-pixbuf-loader
          libavif
          libheif.lib
        ];
      }
    }"
  '';

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix PATH : ${lib.makeBinPath [ xdg-user-dirs ]}
      --prefix PYTHONPATH : ${python3.pkgs.makePythonPath finalAttrs.pythonDependencies}
    )
  '';

  # avoid installing Navidrome at runtime if not available, incompatible with the nix store
  patches = [ ./disable-navidrome-setup.patch ];

  meta = {
    description = "Adwaita music player for OpenSubsonic servers like Navidrome";
    homepage = "https://jeffser.com/nocturne/";
    changelog = "https://github.com/Jeffser/Nocturne/releases";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ pbsds ];
    mainProgram = "nocturne";
    platforms = lib.platforms.linux;
  };
})

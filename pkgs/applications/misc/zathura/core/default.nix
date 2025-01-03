{
  lib,
  stdenv,
  fetchurl,
  meson,
  ninja,
  wrapGAppsHook3,
  pkg-config,
  gitUpdater,
  appstream-glib,
  json-glib,
  desktop-file-utils,
  python3,
  gtk,
  girara,
  gettext,
  gnome,
  libheif,
  libjxl,
  libxml2,
  check,
  sqlite,
  glib,
  texlive,
  libintl,
  libseccomp,
  file,
  librsvg,
  gtk-mac-integration,
  webp-pixbuf-loader,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "zathura";
  version = "0.5.11";

  src = fetchurl {
    url = "https://pwmt.org/projects/zathura/download/zathura-${finalAttrs.version}.tar.xz";
    hash = "sha256-VEWKmZivD7j67y6TSoESe75LeQyG3NLIuPMjZfPRtTw=";
  };

  outputs = [
    "bin"
    "man"
    "dev"
    "out"
  ];

  # Flag list:
  # https://github.com/pwmt/zathura/blob/master/meson_options.txt
  mesonFlags = [
    "-Dmanpages=enabled"
    "-Dconvert-icon=enabled"
    "-Dsynctex=enabled"
    "-Dtests=disabled"
    # Make sure tests are enabled for doCheck
    # (lib.mesonEnable "tests" finalAttrs.finalPackage.doCheck)
    (lib.mesonEnable "seccomp" stdenv.hostPlatform.isLinux)
    (lib.mesonEnable "landlock" stdenv.hostPlatform.isLinux)
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    desktop-file-utils
    python3.pythonOnBuildForHost.pkgs.sphinx
    gettext
    wrapGAppsHook3
    libxml2
    appstream-glib
  ];

  buildInputs =
    [
      gtk
      girara
      libintl
      sqlite
      glib
      file
      librsvg
      check
      json-glib
      texlive.bin.core
    ]
    ++ lib.optional stdenv.hostPlatform.isLinux libseccomp
    ++ lib.optional stdenv.hostPlatform.isDarwin gtk-mac-integration;

  # add support for more image formats
  env.GDK_PIXBUF_MODULE_FILE = gnome._gdkPixbufCacheBuilder_DO_NOT_USE {
    extraLoaders = [
      libheif.out
      libjxl
      librsvg
      webp-pixbuf-loader
    ];
  };

  doCheck = !stdenv.hostPlatform.isDarwin;

  passthru.updateScript = gitUpdater { };

  meta = {
    homepage = "https://pwmt.org/projects/zathura";
    description = "Core component for zathura PDF viewer";
    license = lib.licenses.zlib;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ globin ];
  };
})

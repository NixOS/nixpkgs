{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  wrapGAppsHook4,
  pkg-config,
  gitUpdater,
  appstream-glib,
  json-glib,
  desktop-file-utils,
  python3,
  gtk4,
  girara,
  gettext,
  gnome,
  libheif,
  libjxl,
  libxml2,
  xxhash,
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
  xvfb-run,
  weston,
  versionCheckHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "zathura";
  version = "2026.07.18";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "pwmt";
    repo = "zathura";
    tag = finalAttrs.version;
    hash = "sha256-LngYOW1dNR+x/4Yh1W07dTxidqK0FOvJOl2RRecchvE=";
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
    # by default, zathura searches for zathurarc under $out/etc
    "-Dsysconfdir=/etc"
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
    wrapGAppsHook4
    libxml2
    appstream-glib
  ];

  buildInputs = [
    gtk4
    girara
    libintl
    sqlite
    glib
    file
    librsvg
    check
    json-glib
    texlive.bin.core
    xxhash
  ]
  ++ lib.optional stdenv.hostPlatform.isLinux libseccomp
  ++ lib.optional stdenv.hostPlatform.isDarwin gtk-mac-integration;

  # add support for more image formats
  env.GDK_PIXBUF_MODULE_FILE = gnome._gdkPixbufCacheBuilder_DO_NOT_USE {
    extraLoaders = [
      libheif.lib
      libjxl
      librsvg
      webp-pixbuf-loader
    ];
  };

  doCheck = !stdenv.hostPlatform.isDarwin;

  nativeCheckInputs = [
    xvfb-run
    weston
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = gitUpdater { };

  meta = {
    homepage = "https://pwmt.org/projects/zathura";
    description = "Core component for zathura PDF viewer";
    license = lib.licenses.zlib;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ mithicspirit ];
    mainProgram = "zathura";
  };
})

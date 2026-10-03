{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  gettext,
  pkg-config,
  librsvg,
  sphinx,
  desktop-file-utils,
  appstream,
  gtk4,
  glib,
  girara,
  file, # libmagic
  json-glib,
  sqlite,
  xxhash,
  texlive, # synctex
  libseccomp,
  xvfb-run,
  weston,
  wrapGAppsHook4,
  versionCheckHook,
  gitUpdater,
  zathura,
  gnome,
  libheif,
  libjxl,
  webp-pixbuf-loader,
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
    (lib.mesonEnable "tests-x11" finalAttrs.doCheck)
    (lib.mesonEnable "tests-wayland" finalAttrs.doCheck)
  ];

  nativeBuildInputs = [
    meson
    ninja
    gettext
    pkg-config
    librsvg
    sphinx
    desktop-file-utils
    appstream
    wrapGAppsHook4
  ];

  buildInputs = [
    gtk4
    glib
    girara
    file # libmagic
    json-glib
    sqlite
    xxhash
    texlive.bin.core # synctex
  ] ++
  lib.optionals stdenv.hostPlatform.isLinux [libseccomp];

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

  passthru = {
    updateScript = gitUpdater { };
    tests = {
      inherit zathura;
    };
  };

  meta = {
    homepage = "https://pwmt.org/projects/zathura";
    description = "Core component for zathura PDF viewer";
    license = lib.licenses.zlib;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ mithicspirit ];
    mainProgram = "zathura";
  };
})

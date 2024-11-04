{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
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
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "zathura";
  version = "0.5.8";

  src = fetchFromGitHub {
    owner = "pwmt";
    repo = "zathura";
    rev = finalAttrs.version;
    hash = "sha256-k6DEJpUA3s0mGxE38aYnX7uea98LrzevJhWW1abHo/c=";
  };

  patches = [
    # https://github.com/pwmt/zathura/issues/664
    (fetchpatch {
      name = "fix-build-on-macos.patch";
      url = "https://github.com/pwmt/zathura/commit/53f151f775091abec55ccc4b63893a8f9a668588.patch";
      hash = "sha256-d8lRdlBN1Kfw/aTjz8x0gvTKy+SqSYWHLQCjV7hF5MI=";
    })
  ];

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

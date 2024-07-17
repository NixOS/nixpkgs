{
  lib,
  stdenv,
  fetchFromGitLab,
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
  version = "0.5.5";

  src = fetchFromGitLab {
    domain = "git.pwmt.org";
    owner = "pwmt";
    repo = "zathura";
    rev = finalAttrs.version;
    hash = "sha256-mHEYqgBB55p8nykFtvYtP5bWexp/IqFbeLs7gZmXCeE=";
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

  buildInputs = [
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
  ] ++ lib.optional stdenv.isLinux libseccomp ++ lib.optional stdenv.isDarwin gtk-mac-integration;

  doCheck = !stdenv.isDarwin;

  passthru.updateScript = gitUpdater { };

  meta = with lib; {
    homepage = "https://git.pwmt.org/pwmt/zathura";
    description = "A core component for zathura PDF viewer";
    license = licenses.zlib;
    platforms = platforms.unix;
    maintainers = with maintainers; [ globin ];
  };
})

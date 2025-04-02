{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  gettext,
  desktop-file-utils,
  appstream,
  blueprint-compiler,
  pkg-config,
  gjs,
  gtk4,
  wrapGAppsHook4,
  libadwaita,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ignition";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "flattool";
    repo = "ignition";
    tag = finalAttrs.version;
    hash = "sha256-/s3TMUnhNEBuViRgJVFdF2qELBisIm7sOhyqmHwl+s0=";
  };

  postPatch = ''
    # upstream uses gjs from the build platform instead of the host platform
    # it's not very important, as I don't even know if cross compilation works with GTK
    substituteInPlace src/meson.build \
      --replace-fail "find_program('gjs').full_path()" "'${lib.getExe gjs}'"
  '';

  strictDeps = true;

  nativeBuildInputs = [
    meson
    ninja
    pkg-config

    appstream
    blueprint-compiler
    desktop-file-utils
    gettext
    gtk4
    wrapGAppsHook4
  ];

  buildInputs = [
    libadwaita
  ];

  meta = {
    description = "Manage your startup apps and scripts on Freedesktop Linux distros";
    homepage = "https://github.com/flattool/ignition";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ tomasajt ];
    mainProgram = "ignition";
    platforms = lib.platforms.all;
  };
})

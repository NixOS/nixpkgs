{
  lib,
  stdenv,
  fetchFromGitHub,

  appstream,
  blueprint-compiler,
  desktop-file-utils,
  gettext,
  meson,
  ninja,
  pkg-config,
  typescript,
  wrapGAppsHook4,

  gjs,
  gtk4,
  libadwaita,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ignition";
  version = "2.3.1";

  src = fetchFromGitHub {
    owner = "flattool";
    repo = "ignition";
    tag = finalAttrs.version;
    fetchSubmodules = true;
    hash = "sha256-bkH8nxvqzxzYse7HNRWi79FfuMmLxd/CppKJQk2rTbo=";
  };

  patches = [
    # Don't use find_program for detecting gjs. (we don't want to use the build-platform's gjs binary)
    # We instead rely on the fact that fixupPhase uses patchShebangs on the script.
    # Also, we manually set the effective entrypoint to make gjs properly find our binary.
    ./fix-gjs.patch
  ];

  strictDeps = true;

  nativeBuildInputs = [
    appstream
    blueprint-compiler
    desktop-file-utils
    gettext
    gtk4
    meson
    ninja
    pkg-config
    typescript
    wrapGAppsHook4
  ];

  buildInputs = [
    gjs
    gtk4
    libadwaita
  ];

  # Needed since Jasmine is not in nixpkgs
  mesonFlags = [ "-Dtests=false" ];

  meta = {
    description = "Manage startup apps and scripts";
    homepage = "https://github.com/flattool/ignition";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ tomasajt ];
    mainProgram = "io.github.flattool.Ignition";
    platforms = lib.platforms.linux;
  };
})

{
  lib,
  stdenv,
  appstream,
  blueprint-compiler,
  desktop-file-utils,
  fetchFromGitHub,
  gjs,
  glib,
  gtk4,
  gtksourceview5,
  libadwaita,
  libspelling,
  meson,
  ninja,
  nix-update-script,
  pkg-config,
  wrapGAppsHook4,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "commit";
  version = "4.2";

  src = fetchFromGitHub {
    owner = "sonnyp";
    repo = "Commit";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-L8CI8SAGWhhJyTc8aMPV0s+UevEJGE7n1l7fFnTjdPw=";
    fetchSubmodules = true;
  };

  patches = [
    # Instead of using the absolute path in command snippets,
    # assume `re.sonny.Commit` is already in PATH. This prevents
    # configurations from breaking when our store path changes
    ./command-from-path.patch
  ];

  # gjs uses the invocation name to add gresource files
  # to get around this, we set the entry point name manually
  #
  # `/usr/bin/env` is also used quite a bit
  postPatch = ''
    sed -i "1 a imports.package._findEffectiveEntryPointName = () => 're.sonny.Commit';" src/bin.js
    patchShebangs {,.}*
  '';

  strictDeps = true;

  nativeBuildInputs = [
    appstream
    blueprint-compiler
    desktop-file-utils # for `desktop-file-validate` & `update-desktop-database`
    gjs
    glib # for `glib-compile-schemas`
    gtk4 # for `gtk-update-icon-cache`
    meson
    ninja
    pkg-config
    wrapGAppsHook4
  ];

  buildInputs = [
    gjs
    gtksourceview5
    libadwaita
    libspelling
  ];

  doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Commit message editor";
    homepage = "https://github.com/sonnyp/Commit";
    license = lib.licenses.gpl3Only;
    maintainers = lib.teams.gnome-circle.members;
    mainProgram = "re.sonny.Commit";
    platforms = lib.platforms.linux;
  };
})

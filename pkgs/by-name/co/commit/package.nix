{
  lib,
  stdenv,
  fetchFromGitHub,
  appstream-glib,
  blueprint-compiler,
  desktop-file-utils,
  gjs,
  gtksourceview5,
  libadwaita,
  libspelling,
  meson,
  ninja,
  pkg-config,
  wrapGAppsHook4,
  nix-update-script,
}:
stdenv.mkDerivation rec {
  pname = "commit";
  version = "4.1";

  src = fetchFromGitHub {
    owner = "sonnyp";
    repo = "Commit";
    rev = "v${version}";
    hash = "sha256-HhyoQ4wrc8dHvVU+MylJgaKu9HwSw+/f6UDTIM2YRNk=";
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

  nativeBuildInputs = [
    appstream-glib
    blueprint-compiler
    desktop-file-utils
    meson
    ninja
    pkg-config
    wrapGAppsHook4
  ];

  buildInputs = [
    libadwaita
    libspelling
    gtksourceview5
    gjs
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Commit message editor";
    homepage = "https://github.com/sonnyp/Commit";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ getchoo ];
    mainProgram = "re.sonny.Commit";
    platforms = lib.platforms.linux;
  };
}

{
  lib,
  stdenv,
  fetchFromGitLab,
  blueprint-compiler,
  meson,
  ninja,
  pkg-config,
  vala,
  glib,
  gtk4,
  desktop-file-utils,
  itstool,
  python3,
  json-glib,
  libgee,
  libadwaita,
  libarchive,
  libglycin,
  libglycin-gtk4,
  libhighscore,
  libmanette,
  sqlite,
  libGL,
  libepoxy,
  libpulseaudio,
  SDL2,
  librsvg,
  libmirage,
  feedbackd,
  unstableGitUpdater,
}:

let
  libmanette-1-alpha = libmanette.overrideAttrs (prev: {
    version = "0.2.13-unstable-2025-10-10";
    src = fetchFromGitLab {
      domain = "gitlab.gnome.org";
      owner = "GNOME";
      repo = "libmanette";
      rev = "9b1b45e2aa3221938cd23e5f87a79b69e1996f64";
      hash = "sha256-4Vinc3sBU2PJmOZUOrod6AJbRq6W2nNLcC//FVHGuhg=";
    };

    buildInputs = prev.buildInputs ++ [ libadwaita ];
  });
in
stdenv.mkDerivation (finalAttrs: {
  pname = "highscore-unwrapped";
  version = "0-unstable-2026-02-01";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "World";
    repo = "highscore";
    rev = "281d8e1d7d9abaa8452b869d1d52d4a933a00d26";
    hash = "sha256-HQD8Dge/nSvIDgiekCxHzCmRl4cO98Er8X24ZoP8OiQ=";
  };

  patches = [
    # Highscore finds cores under $out/lib/highscore/cores/
    # Allow the wrapper to override it with $HIGHSCORE_CORES_DIR
    ./cores-dir-from-envvar.patch
  ];

  postPatch = ''
    substituteInPlace meson.build --replace-fail \
      "run_command('git', 'rev-parse', '--short', 'HEAD', check: false).stdout().strip()" \
      "'${finalAttrs.src.rev}'"
  '';

  nativeBuildInputs = [
    blueprint-compiler
    meson
    ninja
    pkg-config
    vala
    glib # For glib-compile-resources
    gtk4 # For gtk4-update-icon-cache
    desktop-file-utils
    itstool
    # Used in build time, detected by meson
    (python3.withPackages (ps: [ ps.pygobject3 ]))
    # To prevent double wrapping, not wrapping it here
    # wrapGAppsHook4
  ];

  buildInputs = [
    glib
    libgee
    gtk4
    json-glib
    libadwaita
    libarchive
    libglycin
    libglycin-gtk4
    libhighscore
    libmanette-1-alpha
    sqlite
    libGL
    libepoxy
    libpulseaudio
    SDL2
    librsvg
    libmirage
    feedbackd
  ];

  passthru.updateScript = unstableGitUpdater {
    hardcodeZeroVersion = true;
  };

  meta = {
    description = "Rewrite of Highscore, formerly gnome-games";
    homepage = "https://gitlab.gnome.org/World/highscore/";
    license = lib.licenses.gpl3Plus;
    inherit (libhighscore.meta) maintainers platforms;
  };
})

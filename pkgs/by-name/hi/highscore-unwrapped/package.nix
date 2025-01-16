{
  lib,
  stdenv,
  fetchFromGitLab,
  meson,
  ninja,
  pkg-config,
  vala,
  glib,
  gtk4,
  desktop-file-utils,
  libgee,
  libadwaita,
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
  hidapi,
  unstableGitUpdater,
}:

let
  # error: The type name `Manette.DeviceType' could not be found
  libmanette' = libmanette.overrideAttrs (old: {
    version = "0.2.9-unstable-2024-11-22";
    src = fetchFromGitLab {
      domain = "gitlab.gnome.org";
      owner = "GNOME";
      repo = "libmanette";
      rev = "08a5f1d53e1fe508b2c90b143fff925b0738e88c";
      hash = "sha256-ScINtc70tnvoPfXS4LIjUNr3SVs6th2B9lHcA6RwyZI=";
    };
    buildInputs = old.buildInputs ++ [ hidapi ];
  });

  # error: The name `InlineViewSwitcher' does not exist in the context of `Adw' (libadwaita-1)
  libadwaita' = libadwaita.overrideAttrs (old: {
    version = "1.6.2-unstable-2024-12-06";
    src = fetchFromGitLab {
      domain = "gitlab.gnome.org";
      owner = "GNOME";
      repo = "libadwaita";
      rev = "6e493edae9b9507c252b954442152d2e84fb7f82";
      hash = "sha256-HexFhMffo6Lq+IOecXmO7XHMjXJghF1JMsFJ//pMS/A=";
    };
  });
in

stdenv.mkDerivation (finalAttrs: {
  pname = "highscore-unwrapped";
  version = "0-unstable-2024-12-25";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "World";
    repo = "highscore";
    rev = "cb6986615694f62b103235409bd124b8abe18c0d";
    hash = "sha256-e4KRCFNs6x9mlvke/WGgAvKpMon90+awXzFLR/vdwRQ=";
  };

  patches = [
    # Highscore finds cores under $out/lib/highscore/cores/
    # Allow the wrapper to override it with $HIGHSCORE_CORES_DIR
    ./cores-dir-from-envvar.patch
  ];

  postPatch = ''
    substituteInPlace meson.build --replace-fail \
      "run_command('git', 'rev-parse', '--short', 'HEAD').stdout().strip()" \
      "'${finalAttrs.src.rev}'"
  '';

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    vala
    glib # For glib-compile-resources
    gtk4 # For gtk4-update-icon-cache
    desktop-file-utils
    # To prevent double wrapping, not wrapping it here
    # wrapGAppsHook4
  ];

  buildInputs = [
    glib
    libgee
    gtk4
    libadwaita'
    libhighscore
    libmanette'
    sqlite
    libGL
    libepoxy
    libpulseaudio
    SDL2
    librsvg
    (libmirage.override { withVala = true; })
    feedbackd
  ];

  passthru.updateScript = unstableGitUpdater {
    url = finalAttrs.src.gitRepoUrl;
    hardcodeZeroVersion = true;
  };

  meta = {
    description = "Rewrite of Highscore, formerly gnome-games";
    homepage = "https://gitlab.gnome.org/World/highscore/";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ chuangzhu ];
    platforms = lib.platforms.linux;
  };
})

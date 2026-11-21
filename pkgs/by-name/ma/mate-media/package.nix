{
  lib,
  stdenv,
  fetchFromGitHub,
  autoconf-archive,
  autoreconfHook,
  pkg-config,
  gettext,
  libtool,
  gtk-layer-shell,
  gtk3,
  libcanberra-gtk3,
  libmatemixer,
  libxml2,
  mate-common,
  mate-desktop,
  mate-panel,
  wayland,
  wrapGAppsHook3,
  gitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mate-media";
  version = "1.28.2";
  outputs = [
    "out"
    "man"
  ];

  src = fetchFromGitHub {
    owner = "mate-desktop";
    repo = "mate-media";
    tag = "v${finalAttrs.version}";
    hash = "sha256-vJGR/9uTzmJM5ZdMhONGbkvCa08hH5LBHo+i6PRgsIw=";
  };

  nativeBuildInputs = [
    autoconf-archive
    autoreconfHook
    pkg-config
    gettext
    libtool
    mate-common # mate-common.m4 macros
    wrapGAppsHook3
  ];

  buildInputs = [
    gtk-layer-shell
    gtk3
    libcanberra-gtk3
    libmatemixer
    libxml2
    mate-desktop
    mate-panel
    wayland
  ];

  configureFlags = [ "--enable-in-process" ];

  enableParallelBuilding = true;

  passthru.updateScript = gitUpdater {
    odd-unstable = true;
    rev-prefix = "v";
  };

  meta = {
    description = "Media tools for MATE";
    homepage = "https://mate-desktop.org";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ chpatrick ];
    teams = [ lib.teams.mate ];
  };
})

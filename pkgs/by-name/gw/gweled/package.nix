{
  lib,
  stdenv,
  fetchgit,
  meson,
  ninja,
  pkg-config,
  wrapGAppsHook3,
  desktop-file-utils,
  clutter,
  clutter-gtk,
  gsound,
  libgnome-games-support,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gweled";
  version = "1.0-beta1";

  src = fetchgit {
    url = "https://git.launchpad.net/gweled";
    tag = finalAttrs.version;
    hash = "sha256-cm1z6l2tfYBFVFcvsnQ6cI3pQDnJMzn6SUC20gnBF5w=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    wrapGAppsHook3
    desktop-file-utils
  ];

  buildInputs = [
    clutter
    clutter-gtk
    gsound
    libgnome-games-support
  ];

  configureFlags = [ "--disable-setgid" ];

  meta = {
    description = "Puzzle game similar to Bejeweled or Diamond Mine";
    mainProgram = "gweled";
    homepage = "https://gweled.org";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ aleksana ];
  };
})

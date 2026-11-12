{
  stdenv,
  lib,
  fetchFromGitHub,
  gdk-pixbuf,
  glib,
  meson,
  ninja,
  pkg-config,
  sassc,
  librsvg,
  gitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "greybird";
  version = "3.23.4";

  src = fetchFromGitHub {
    owner = "shimmerproject";
    repo = "greybird";
    rev = "v${finalAttrs.version}";
    hash = "sha256-De8y+LRQ26UKrUECLCcbCg7p9Z+aRssQ/7YzegAUPw4=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    gdk-pixbuf
    glib
    meson
    ninja
    pkg-config
    sassc
  ];

  buildInputs = [
    librsvg
  ];

  passthru.updateScript = gitUpdater { rev-prefix = "v"; };

  meta = {
    description = "Desktop suite for Xfce";
    homepage = "https://github.com/shimmerproject/Greybird";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    teams = [ lib.teams.xfce ];
  };
})

{
  lib,
  stdenv,
  fetchFromGitLab,
  autoreconfHook,
  wrapGAppsHook3,
  intltool,
  itstool,
  pkg-config,
  vala,
  glib,
  graphviz,
  yelp-tools,
  gtk3,
  lrzsz,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "moserial";
  version = "3.0.21";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "GNOME";
    repo = "moserial";
    rev = "moserial_${lib.replaceStrings [ "." ] [ "_" ] finalAttrs.version}";
    sha256 = "sha256-wfdI51ECqVNcUrIVjYBijf/yqpiwSQeMiKaVJSSma3k=";
  };

  nativeBuildInputs = [
    autoreconfHook
    intltool
    itstool
    pkg-config
    vala
    wrapGAppsHook3
  ];

  buildInputs = [
    glib
    graphviz
    yelp-tools
    gtk3
  ];

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix PATH : ${lib.makeBinPath [ lrzsz ]}
    )
  '';

  meta = {
    description = "Clean, friendly gtk-based serial terminal for the gnome desktop";
    homepage = "https://gitlab.gnome.org/GNOME/moserial";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ linsui ];
    platforms = lib.platforms.linux;
    mainProgram = "moserial";
  };
})

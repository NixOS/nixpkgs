{
  stdenv,
  lib,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  wrapGAppsHook4,
  glib,
  glib-networking,
  gnome-online-accounts,
  gtk4,
  libadwaita,
  xapp-symbolic-icons,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gnome-online-accounts-gtk";
  version = "3.50.10";

  src = fetchFromGitHub {
    owner = "xapp-project";
    repo = "gnome-online-accounts-gtk";
    rev = finalAttrs.version;
    hash = "sha256-tBBCnB3JhGaaN/uv6BqyJDSvSyV1mPA4WvsvNS8cbOA=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    wrapGAppsHook4
  ];

  buildInputs = [
    glib
    glib-networking
    gnome-online-accounts
    gtk4
    libadwaita # for goa-backend
  ];

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix XDG_DATA_DIRS : ${lib.makeSearchPath "share" [ xapp-symbolic-icons ]}
    )
  '';

  meta = {
    description = "Online accounts configuration utility";
    homepage = "https://github.com/xapp-project/gnome-online-accounts-gtk";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    teams = [ lib.teams.cinnamon ];
  };
})

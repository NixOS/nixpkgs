{
  fetchFromGitHub,
  cinnamon-desktop,
  cinnamon-settings-daemon,
  cinnamon-translations,
  glib,
  gsettings-desktop-schemas,
  gtk3,
  libcanberra,
  libxslt,
  meson,
  ninja,
  pkg-config,
  python3,
  lib,
  stdenv,
  systemd,
  wrapGAppsHook3,
  xapp,
  libxtst,
  libxrender,
  libxext,
  libxcomposite,
  libxau,
  libx11,
  xtrans,
  libexecinfo,
  pango,
}:

let
  pythonEnv = python3.withPackages (
    pp: with pp; [
      python-xapp
      pygobject3
      setproctitle
    ]
  );
in
stdenv.mkDerivation rec {
  pname = "cinnamon-session";
  version = "6.6.1";

  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = "cinnamon-session";
    tag = version;
    hash = "sha256-zPfyPBKN9Qqs2UndW0vYzBqmeFla3ytvdcv/X2dv1zs=";
  };

  buildInputs = [
    # meson.build
    cinnamon-desktop
    gtk3
    glib
    libcanberra
    pango
    libx11
    libxext
    xapp
    libxau
    libxcomposite

    systemd

    libxtst
    libxrender
    xtrans

    # other (not meson.build)
    cinnamon-settings-daemon
    gsettings-desktop-schemas
    pythonEnv # for cinnamon-session-quit
  ];

  nativeBuildInputs = [
    meson
    ninja
    wrapGAppsHook3
    libexecinfo
    python3
    pkg-config
    libxslt
  ];

  mesonFlags = [
    # use locales from cinnamon-translations
    "--localedir=${cinnamon-translations}/share/locale"
  ];

  postPatch = ''
    # patchShebangs requires executable file
    chmod +x data/meson_install_schemas.py
    patchShebangs data/meson_install_schemas.py
  '';

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix XDG_DATA_DIRS : "${cinnamon-desktop}/share"
      --prefix XDG_CONFIG_DIRS : "${cinnamon-settings-daemon}/etc/xdg"
    )
  '';

  meta = {
    homepage = "https://github.com/linuxmint/cinnamon-session";
    description = "Cinnamon session manager";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.linux;
    teams = [ lib.teams.cinnamon ];
  };
}

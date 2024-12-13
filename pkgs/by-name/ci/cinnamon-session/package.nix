{
  fetchFromGitHub,
  cinnamon-desktop,
  cinnamon-settings-daemon,
  cinnamon-translations,
  dbus-glib,
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
  xorg,
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
  version = "6.4.0";

  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = pname;
    rev = version;
    hash = "sha256-4uTKcmwfEytoAy4CFiOedYJqmPtBFBHk0P1gEGgm6pU=";
  };

  patches = [
    ./0001-Use-dbus_glib-instead-of-elogind.patch
  ];

  buildInputs = [
    # meson.build
    cinnamon-desktop
    gtk3
    glib
    libcanberra
    pango
    xorg.libX11
    xorg.libXext
    xapp
    xorg.libXau
    xorg.libXcomposite

    systemd

    xorg.libXtst
    xorg.libXrender
    xorg.xtrans

    # other (not meson.build)
    cinnamon-settings-daemon
    dbus-glib
    glib
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

  meta = with lib; {
    homepage = "https://github.com/linuxmint/cinnamon-session";
    description = "Cinnamon session manager";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = teams.cinnamon.members;
  };
}

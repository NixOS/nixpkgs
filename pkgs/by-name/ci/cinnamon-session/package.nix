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
<<<<<<< HEAD
  version = "6.6.1";
=======
  version = "6.4.2";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = "cinnamon-session";
    tag = version;
<<<<<<< HEAD
    hash = "sha256-zPfyPBKN9Qqs2UndW0vYzBqmeFla3ytvdcv/X2dv1zs=";
=======
    hash = "sha256-zv1X1MLZBg+Bayd4hjsmrdXkFTRkH4kz7PJe6mFTBqc=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

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

<<<<<<< HEAD
  meta = {
    homepage = "https://github.com/linuxmint/cinnamon-session";
    description = "Cinnamon session manager";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.linux;
    teams = [ lib.teams.cinnamon ];
=======
  meta = with lib; {
    homepage = "https://github.com/linuxmint/cinnamon-session";
    description = "Cinnamon session manager";
    license = licenses.gpl2;
    platforms = platforms.linux;
    teams = [ teams.cinnamon ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}

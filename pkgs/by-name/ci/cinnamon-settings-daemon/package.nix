{
  fetchFromGitHub,
  cinnamon-desktop,
  cinnamon-translations,
  colord,
  glib,
  gsettings-desktop-schemas,
  gtk3,
  lcms2,
  libcanberra-gtk3,
  libgnomekbd,
  libnotify,
  libxklavier,
  wrapGAppsHook3,
  pkg-config,
  lib,
  stdenv,
  systemd,
  upower,
  dconf,
  cups,
  polkit,
  librsvg,
  libwacom,
  xorg,
  fontconfig,
  tzdata,
  nss,
  libgudev,
  meson,
  ninja,
}:

stdenv.mkDerivation rec {
  pname = "cinnamon-settings-daemon";
  version = "6.4.2";

  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = pname;
    rev = version;
    hash = "sha256-VnplZ9HDmrBuDybV5YJBbqaETdUQHdUfgsTZ+Zj1/4c=";
  };

  patches = [
    ./csd-backlight-helper-fix.patch
  ];

  buildInputs = [
    cinnamon-desktop
    colord
    gtk3
    glib
    gsettings-desktop-schemas
    lcms2
    libcanberra-gtk3
    libgnomekbd
    libnotify
    libxklavier
    systemd
    upower
    dconf
    cups
    polkit
    librsvg
    libwacom
    xorg.libXext
    xorg.libX11
    xorg.libXi
    xorg.libXfixes
    fontconfig
    nss
    libgudev
  ];

  nativeBuildInputs = [
    meson
    ninja
    wrapGAppsHook3
    pkg-config
  ];

  outputs = [
    "out"
    "dev"
  ];

  postPatch = ''
    sed "s|/usr/share/zoneinfo|${tzdata}/share/zoneinfo|g" -i plugins/datetime/system-timezone.h
  '';

  # use locales from cinnamon-translations (not using --localedir because datadir is used)
  postInstall = ''
    ln -s ${cinnamon-translations}/share/locale $out/share/locale
  '';

  # So the polkit policy can reference /run/current-system/sw/bin/cinnamon-settings-daemon/csd-backlight-helper
  postFixup = ''
    mkdir -p $out/bin/cinnamon-settings-daemon
    ln -s $out/libexec/csd-backlight-helper $out/bin/cinnamon-settings-daemon/csd-backlight-helper
  '';

  meta = with lib; {
    homepage = "https://github.com/linuxmint/cinnamon-settings-daemon";
    description = "Settings daemon for the Cinnamon desktop";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = teams.cinnamon.members;
  };
}

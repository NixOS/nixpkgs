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
  libnotify,
  wrapGAppsHook3,
  pkg-config,
  lib,
  stdenv,
  systemd,
  upower,
  cups,
  polkit,
  librsvg,
  libwacom,
  libxi,
  libxext,
  libx11,
  fontconfig,
  tzdata,
  nss,
  libgudev,
  meson,
  ninja,
}:

stdenv.mkDerivation rec {
  pname = "cinnamon-settings-daemon";
  version = "6.6.3";

  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = "cinnamon-settings-daemon";
    tag = version;
    hash = "sha256-sa3DYH4/yRycHyrAG8IfCCpHhFNKwq8yOgLoKHprGfk=";
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
    libnotify
    systemd
    upower
    cups
    polkit
    librsvg
    libwacom
    libxext
    libx11
    libxi
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

  meta = {
    homepage = "https://github.com/linuxmint/cinnamon-settings-daemon";
    description = "Settings daemon for the Cinnamon desktop";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.linux;
    teams = [ lib.teams.cinnamon ];
  };
}

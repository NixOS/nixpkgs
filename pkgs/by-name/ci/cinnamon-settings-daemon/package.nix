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
<<<<<<< HEAD
  libnotify,
=======
  libgnomekbd,
  libnotify,
  libxklavier,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  wrapGAppsHook3,
  pkg-config,
  lib,
  stdenv,
  systemd,
  upower,
<<<<<<< HEAD
=======
  dconf,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
<<<<<<< HEAD
  version = "6.6.1";
=======
  version = "6.4.3";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = "cinnamon-settings-daemon";
    tag = version;
<<<<<<< HEAD
    hash = "sha256-WK7MU63M3B0C4Dsik6j4cDyBTZlkF6pofZi2aJcH9eI=";
=======
    hash = "sha256-L7+OgymYoYBdprw66RW8tiGA7XGWjTBpDpXhli8Fjoo=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
<<<<<<< HEAD
    libnotify
    systemd
    upower
=======
    libgnomekbd
    libnotify
    libxklavier
    systemd
    upower
    dconf
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    cups
    polkit
    librsvg
    libwacom
    xorg.libXext
    xorg.libX11
    xorg.libXi
<<<<<<< HEAD
=======
    xorg.libXfixes
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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

<<<<<<< HEAD
  meta = {
    homepage = "https://github.com/linuxmint/cinnamon-settings-daemon";
    description = "Settings daemon for the Cinnamon desktop";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.linux;
    teams = [ lib.teams.cinnamon ];
=======
  meta = with lib; {
    homepage = "https://github.com/linuxmint/cinnamon-settings-daemon";
    description = "Settings daemon for the Cinnamon desktop";
    license = licenses.gpl2;
    platforms = platforms.linux;
    teams = [ teams.cinnamon ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}

{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  meson,
  ninja,
  pkg-config,
  sassc,
  vala,
  wrapGAppsHook4,
  gnome-settings-daemon,
  gtk4,
  pango,
  pantheon,
}:

stdenv.mkDerivation rec {
  pname = "pantheon-tweaks";
  version = "2.5.1";

  src = fetchFromGitHub {
    owner = "pantheon-tweaks";
    repo = "pantheon-tweaks";
    rev = version;
    hash = "sha256-haiKElDv6lvZeROpiCc2n3I0Ho/l6HjUhu/yBISsT2E=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    sassc
    vala
    wrapGAppsHook4
  ];

  buildInputs = [
    gnome-settings-daemon # org.gnome.settings-daemon.plugins.xsettings
    gtk4
    pango
  ]
  ++ (with pantheon; [
    elementary-files # io.elementary.files.preferences
    elementary-terminal # io.elementary.terminal.settings
    granite7
    switchboard
    wingpanel-indicator-sound # io.elementary.desktop.wingpanel.sound
  ]);

  mesonFlags = [
    "-Dsystheme_rootdir=/run/current-system/sw/share"
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Unofficial system customization app for Pantheon";
    longDescription = ''
      Unofficial system customization app for Pantheon
      that lets you easily and safely customise your desktop's appearance.
    '';
    homepage = "https://github.com/pantheon-tweaks/pantheon-tweaks";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    teams = [ lib.teams.pantheon ];
    mainProgram = "pantheon-tweaks";
  };
}

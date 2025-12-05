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
  version = "2.5.0";

  src = fetchFromGitHub {
    owner = "pantheon-tweaks";
    repo = "pantheon-tweaks";
    rev = version;
    hash = "sha256-cCrHGOo7dZc28hbZD6Zv8Dw4Ks5JTDsm6A6nkmpUAxk=";
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

  meta = with lib; {
    description = "Unofficial system customization app for Pantheon";
    longDescription = ''
      Unofficial system customization app for Pantheon
      that lets you easily and safely customise your desktop's appearance.
    '';
    homepage = "https://github.com/pantheon-tweaks/pantheon-tweaks";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    teams = [ teams.pantheon ];
    mainProgram = "pantheon-tweaks";
  };
}

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
  gtk4,
  libgee,
  pango,
  pantheon,
}:

stdenv.mkDerivation rec {
  pname = "pantheon-tweaks";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "pantheon-tweaks";
    repo = pname;
    rev = version;
    hash = "sha256-NrDBr7Wtfxf9UA/sbi9ilgrlxK6QGQAopuz3TV2ITjs=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    sassc
    vala
    wrapGAppsHook4
  ];

  buildInputs =
    [
      gtk4
      libgee
      pango
    ]
    ++ (with pantheon; [
      elementary-files # settings schemas
      elementary-terminal # settings schemas
      granite7
      switchboard
    ]);

  postPatch = ''
    substituteInPlace src/Settings/ThemeSettings.vala \
      --replace-fail "/usr/share/" "/run/current-system/sw/share/"
  '';

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
    maintainers = teams.pantheon.members;
    mainProgram = "pantheon-tweaks";
  };
}

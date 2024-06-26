{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  meson,
  ninja,
  pkg-config,
  python3,
  vala,
  wrapGAppsHook3,
  gtk3,
  libgee,
  pantheon,
}:

stdenv.mkDerivation rec {
  pname = "pantheon-tweaks";
  version = "2.0.2";

  src = fetchFromGitHub {
    owner = "pantheon-tweaks";
    repo = pname;
    rev = version;
    hash = "sha256-7a6maEpvmIS+Raawr9ec44nCbuj83EUnd+8RqYgWy24=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    python3
    vala
    wrapGAppsHook3
  ];

  buildInputs =
    [
      gtk3
      libgee
    ]
    ++ (with pantheon; [
      elementary-files # settings schemas
      elementary-terminal # settings schemas
      granite
    ]);

  postPatch = ''
    chmod +x meson/post_install.py
    patchShebangs meson/post_install.py

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

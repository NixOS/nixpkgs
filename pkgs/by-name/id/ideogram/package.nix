{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  vala,
  pkg-config,
  python3,
  glib,
  gtk3,
  meson,
  ninja,
  libgee,
  pantheon,
  desktop-file-utils,
  libxtst,
  libx11,
  wrapGAppsHook3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ideogram";
  version = "1.3.3";

  src = fetchFromGitHub {
    owner = "cassidyjames";
    repo = "ideogram";
    rev = finalAttrs.version;
    hash = "sha256-4aYD7Uco47R0iUMHRLcxP0YY/O+zCazHKxZOIUA/ef4=";
  };

  nativeBuildInputs = [
    desktop-file-utils
    meson
    ninja
    vala
    pkg-config
    python3
    wrapGAppsHook3
  ];

  buildInputs = [
    glib
    gtk3
    libgee
    pantheon.granite
    libx11
    libxtst
  ];

  postPatch = ''
    chmod +x meson/post_install.py
    patchShebangs meson/post_install.py
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Insert emoji anywhere, even in non-native apps - designed for elementary OS";
    homepage = "https://github.com/cassidyjames/ideogram";
    license = lib.licenses.gpl2Plus;
    teams = [ lib.teams.pantheon ];
    platforms = lib.platforms.linux;
    mainProgram = "com.github.cassidyjames.ideogram";
  };

})

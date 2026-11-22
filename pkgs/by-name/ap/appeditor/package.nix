{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  vala,
  meson,
  ninja,
  pkg-config,
  pantheon,
  python3,
  gettext,
  glib,
  gtk3,
  libgee,
  wrapGAppsHook3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "appeditor";
  version = "1.1.5";

  src = fetchFromGitHub {
    owner = "donadigo";
    repo = "appeditor";
    tag = finalAttrs.version;
    sha256 = "sha256-A0YasHw5osGrgUPiUPuRBnv1MR/Pth6jVHGEx/klOGY=";
  };

  nativeBuildInputs = [
    gettext
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
    pantheon.granite
    libgee
  ];

  postPatch = ''
    chmod +x meson/post_install.py
    patchShebangs meson/post_install.py
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Edit the Pantheon desktop application menu";
    homepage = "https://github.com/donadigo/appeditor";
    maintainers = with lib.maintainers; [ xiorcale ];
    teams = [ lib.teams.pantheon ];
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl3Plus;
    mainProgram = "com.github.donadigo.appeditor";
  };
})

{
  lib,
  stdenv,
  fetchFromGitLab,
  replaceVars,
  meson,
  ninja,
  pkg-config,
  vala,
  gettext,
  itstool,
  desktop-file-utils,
  glib,
  glib-networking,
  gtk4,
  coreutils,
  libsoup_3,
  libsecret,
  libadwaita,
  wrapGAppsHook4,
  libgpg-error,
  json-glib,
  duplicity,
  rclone,
  restic,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "deja-dup";
  version = "48.2";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "World";
    repo = "deja-dup";
    rev = finalAttrs.version;
    hash = "sha256-g6bGOlpiEMJ9d+xe2GJyTBWAuGlY9EZTlJaYhB/5Ldw=";
  };

  patches = [
    (replaceVars ./fix-paths.patch {
      inherit coreutils;
    })
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    vala
    gettext
    itstool
    desktop-file-utils
    wrapGAppsHook4
  ];

  buildInputs = [
    libsoup_3
    glib
    glib-networking
    gtk4
    libsecret
    libadwaita
    libgpg-error
    json-glib
  ];

  mesonFlags = [
    "-Dduplicity_command=${lib.getExe duplicity}"
    "-Drclone_command=${lib.getExe rclone}"
    "-Denable_restic=true"
    "-Drestic_command=${lib.getExe restic}"
  ];

  preFixup = ''
    gappsWrapperArgs+=(
      # Required by duplicity
      --prefix PATH : "${lib.makeBinPath [ rclone ]}"
    )
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Simple backup tool";
    longDescription = ''
      Déjà Dup is a simple backup tool. It hides the complexity \
      of backing up the Right Way (encrypted, off-site, and regular) \
      and uses duplicity as the backend.
    '';
    homepage = "https://apps.gnome.org/DejaDup/";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ jtojnar ];
    teams = [ lib.teams.gnome-circle ];
    platforms = lib.platforms.linux;
    mainProgram = "deja-dup";
  };
})

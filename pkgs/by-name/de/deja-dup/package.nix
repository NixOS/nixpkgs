{
  lib,
  stdenv,
  fetchFromGitLab,
  meson,
  ninja,
  pkg-config,
  vala,
  gettext,
  itstool,
  blueprint-compiler,
  desktop-file-utils,
  glib,
  glib-networking,
  gtk4,
  libsoup_3,
  libsecret,
  libadwaita,
  wrapGAppsHook4,
  libgpg-error,
  json-glib,
  borgbackup,
  duplicity,
  fuse,
  rclone,
  restic,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "deja-dup";
  version = "49.2";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "World";
    repo = "deja-dup";
    tag = finalAttrs.version;
    hash = "sha256-yH4XX1MwPxTmKh6p27pYQBQDyeGIT+Ed9E0Y508EF7s=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    vala
    gettext
    itstool
    blueprint-compiler
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
    # Check https://gitlab.gnome.org/World/deja-dup/-/blob/main/meson.options
    (lib.mesonOption "borg_command" (lib.getExe borgbackup))
    (lib.mesonOption "duplicity_command" (lib.getExe duplicity))
    (lib.mesonOption "fusermount_command" (lib.getExe' fuse "fusermount"))
    (lib.mesonOption "rclone_command" (lib.getExe rclone))
    (lib.mesonOption "restic_command" (lib.getExe restic))
    (lib.mesonEnable "packagekit" false) # packagekit-glib not packaged
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
      Déjà Dup is a simple backup tool. It hides the complexity
      of backing up the Right Way (encrypted, off-site, and regular)
      and uses duplicity as the backend.
    '';
    homepage = "https://apps.gnome.org/DejaDup/";
    changelog = "https://gitlab.gnome.org/World/deja-dup/-/releases/${finalAttrs.version}";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ jtojnar ];
    teams = [ lib.teams.gnome-circle ];
    platforms = lib.platforms.linux;
    mainProgram = "deja-dup";
  };
})

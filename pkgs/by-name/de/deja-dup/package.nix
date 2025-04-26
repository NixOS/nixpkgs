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
  version = "48.1";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "World";
    repo = "deja-dup";
    tag = finalAttrs.version;
    hash = "sha256-pB5J+ElSnAE7rX74mgQBgnbOTVFJk/zOUBsJmnVETUE=";
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
    (lib.mesonOption "duplicity_command" (lib.getExe duplicity))
    (lib.mesonOption "restic_command" (lib.getExe rclone))
    (lib.mesonOption "restic_command" (lib.getExe restic))
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
    maintainers = with lib.maintainers; [ jtojnar ] ++ lib.teams.gnome-circle.members;
    platforms = lib.platforms.linux;
    mainProgram = "deja-dup";
  };
})

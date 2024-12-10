{ lib, stdenv
, fetchFromGitLab
, substituteAll
, meson
, ninja
, pkg-config
, vala
, gettext
, itstool
, desktop-file-utils
, glib
, gtk4
, coreutils
, libsoup_3
, libsecret
, libadwaita
, wrapGAppsHook4
, libgpg-error
, json-glib
, duplicity
, rclone
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "deja-dup";
  version = "46.1";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "World";
    repo = "deja-dup";
    rev = finalAttrs.version;
    hash = "sha256-tKVY0wewBDx0AMzmTdko8vGg5bNGfYohgcSDg5Oky30=";
  };

  patches = [
    (substituteAll {
      src = ./fix-paths.patch;
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
    gtk4
    libsecret
    libadwaita
    libgpg-error
    json-glib
  ];

  mesonFlags = [
    "-Dduplicity_command=${lib.getExe duplicity}"
    "-Drclone_command=${lib.getExe rclone}"
  ];

  preFixup = ''
    gappsWrapperArgs+=(
      # Required by duplicity
      --prefix PATH : "${lib.makeBinPath [ rclone ]}"
    )
  '';

  meta = with lib; {
    description = "Simple backup tool";
    longDescription = ''
      Déjà Dup is a simple backup tool. It hides the complexity \
      of backing up the Right Way (encrypted, off-site, and regular) \
      and uses duplicity as the backend.
    '';
    homepage = "https://apps.gnome.org/DejaDup/";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ jtojnar ];
    platforms = platforms.linux;
    mainProgram = "deja-dup";
  };
})

{
  stdenv,
  lib,
  fetchFromGitLab,
  python3,
  meson,
  ninja,
  cmake,
  vala,
  gettext,
  desktop-file-utils,
  appstream-glib,
  glib,
  pkg-config,
  libadwaita,
  nix-update-script,
  gtksourceview5,
  wrapGAppsHook4,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "snoop";
  version = "0.4.2";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "philippun1";
    repo = "snoop";
    tag = finalAttrs.version;
    hash = "sha256-M+wV6WYPtTbKXgBCOD/qN3LYAbpucwSAuKZQBVUjZo8=";
  };

  patchPhase = ''
    runHook prePatch

    substituteInPlace build-aux/meson/postinstall.py \
      --replace-fail "/usr/bin/env python3" "${lib.getExe python3}"

    sed -i '/gtk-update-icon-cache/d' build-aux/meson/postinstall.py
    sed -i '/update-desktop-database/d' build-aux/meson/postinstall.py

    runHook postPatch
  '';

  nativeBuildInputs = [
    meson
    ninja
    cmake
    gettext
    vala
    desktop-file-utils
    appstream-glib
    pkg-config
    wrapGAppsHook4
  ];

  buildInputs = [
    glib
    libadwaita
    gtksourceview5
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://gitlab.gnome.org/philippun1/snoop";
    changelog = "https://gitlab.gnome.org/philippun1/snoop/-/releases/${finalAttrs.version}";
    description = "Search through file contents in a given folder";
    maintainers = with lib.maintainers; [ bot-wxt1221 ];
    license = lib.licenses.gpl3Plus;
    mainProgram = "snoop";
    platforms = lib.platforms.unix;
  };
})

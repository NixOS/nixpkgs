{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  vala,
  glib,
  gtk4,
  libadwaita,
  wrapGAppsHook4,
  appstream-glib,
  desktop-file-utils,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "spedread";
<<<<<<< HEAD
  version = "2.6.1";
=======
  version = "2.5.1";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "Darazaki";
    repo = "Spedread";
    tag = "v${finalAttrs.version}";
<<<<<<< HEAD
    hash = "sha256-xIVPK0T5wrxlNNWHZnxbW62ZZnagTzoe3OLiW0QtLSQ=";
=======
    hash = "sha256-0VQdiosYd4HBFM1A9jvtQulvgiRwMoClXAVwLhGh6xU=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  postPatch = ''
    substituteInPlace meson.build \
      --replace-fail "meson.add_install_script('build-aux/meson/postinstall.py')" ""
  '';

  nativeBuildInputs = [
    meson
    ninja
    vala
    pkg-config
    wrapGAppsHook4
    appstream-glib
    desktop-file-utils
  ];

  buildInputs = [
    glib
    gtk4
    libadwaita
  ];

  postInstall = ''
    gtk4-update-icon-cache -qtf "$out/share/icons/hicolor"
    update-desktop-database -q "$out/share/applications"
    glib-compile-schemas "$out/share/glib-2.0/schemas"
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Rapid word display tool for improved reading focus and reduced eye movement";
    homepage = "https://github.com/Darazaki/Spedread";
    changelog = "https://github.com/Darazaki/Spedread/releases/tag/${finalAttrs.version}";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ thtrf ];
    platforms = lib.platforms.linux;
    mainProgram = "spedread";
  };
})

{
  lib,
  desktop-file-utils,
  exempi,
  fetchFromGitHub,
  glib,
  gtk4,
  libadwaita,
  meson,
  ninja,
  nix-update-script,
  pkg-config,
  poppler,
  stdenv,
  vala,
  wrapGAppsHook4,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "paper-clip";
  version = "5.5.1";

  src = fetchFromGitHub {
    owner = "Diego-Ivan";
    repo = "Paper-Clip";
    rev = "v${finalAttrs.version}";
    hash = "sha256-Jdsx5ZhujP0SgEtr4NMbXsTkMYrkQj7Vs+SSYziWpiw=";
  };

  # Remove these patches after the version is bumped past 5.5.1
  patches = [
    ./document-Copy-using-SubprocessLauncher-instead-of-GFile-API.patch
    ./vala-Solve-Vala-errors-at-C-compile-time.patch
  ];

  nativeBuildInputs = [
    desktop-file-utils
    meson
    ninja
    pkg-config
    vala
    wrapGAppsHook4
  ];

  buildInputs = [
    exempi
    glib
    gtk4
    libadwaita
    poppler
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    changelog = "https://github.com/Diego-Ivan/Paper-Clip/releases/tag/v${finalAttrs.version}";
    description = "Edit PDF document metadata";
    homepage = "https://github.com/Diego-Ivan/Paper-Clip";
    license = lib.licenses.gpl3Plus;
    mainProgram = "pdf-metadata-editor";
    maintainers = lib.teams.gnome-circle.members;
    platforms = lib.platforms.linux;
  };
})

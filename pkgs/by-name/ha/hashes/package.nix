{
  stdenv,
  lib,
  fetchFromGitHub,
  nix-update-script,
  adwaita-icon-theme,
  gtk4,
  libadwaita,
  desktop-file-utils,
  wrapGAppsHook4,
  meson,
  ninja,
  pkg-config,
  cmake,
  python3,
  appstream,
  fetchPypi,
  gobject-introspection,
  glib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hashes";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "zefr0x";
    repo = "hashes";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-BmfSCHs+JcpsAG8AhaYf+SDFI+LdJKMKgBIodd66qmw=";
  };

  nativeBuildInputs = [
    meson
    ninja
    desktop-file-utils
    cmake
    pkg-config
    appstream
    gobject-introspection
    wrapGAppsHook4
  ];

  buildInputs = [
    gtk4
    libadwaita
    glib
    adwaita-icon-theme
    (python3.withPackages (
      ps: with ps; [
        name-that-hash
        pygobject3
      ]
    ))
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/zefr0x/hashes/tree/main";
    changelog = "https://github.com/zefr0x/hashes/releases/tag/v${finalAttrs.version}";
    description = "Simple hash algorithm identification GUI";
    maintainers = with lib.maintainers; [ bot-wxt1221 ];
    license = lib.licenses.gpl3Plus;
    mainProgram = "hashes";
    platforms = lib.platforms.unix;
  };
})

{
  lib,
  stdenv,
  fetchFromGitLab,
  pkg-config,
  meson,
  ninja,
  wrapGAppsHook4,
  enchant,
  gtkmm4,
  libgcrypt,
  gtk3,
  shared-mime-info,
  libshumate,
  nix-update-script,
  python3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lifeograph";
  version = "3.1.4";

  src = fetchFromGitLab {
    owner = "bilheps";
    repo = "lifeograph";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Tsvuc6s8D45WKCTWSqRBIVu1zOjx43edBlAw/TLOGV0=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    gtk3 # for gtk-update-icon-cache (meson post-install script)
    shared-mime-info # for update-mime-database
    wrapGAppsHook4
    python3.pkgs.pybind11
  ];

  buildInputs = [
    libgcrypt
    enchant
    gtkmm4
    libshumate
    python3
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://lifeograph.sourceforge.net/doku.php?id=start";
    description = "Off-line and private journal and note taking application";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ kyehn ];
    mainProgram = "lifeograph";
    platforms = lib.platforms.linux;
  };
})

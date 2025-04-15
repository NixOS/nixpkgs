{
  stdenvNoCC,
  lib,
  fetchFromGitHub,
  nix-update-script,
  meson,
  ninja,
  sassc,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "adw-gtk3";
  version = "5.8";

  src = fetchFromGitHub {
    owner = "lassekongo83";
    repo = "adw-gtk3";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Z/A2vn/P0EWoihYHFk+ELsxffzA8ypxv61ZURCSC/W0=";
  };

  nativeBuildInputs = [
    meson
    ninja
    sassc
  ];

  postPatch = ''
    chmod +x gtk/src/adw-gtk3-dark/gtk-3.0/install-dark-theme.sh
    patchShebangs gtk/src/adw-gtk3-dark/gtk-3.0/install-dark-theme.sh
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Theme from libadwaita ported to GTK-3";
    homepage = "https://github.com/lassekongo83/adw-gtk3";
    license = lib.licenses.lgpl21Only;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ ciferkey ];
  };
})

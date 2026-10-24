{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  meson,
  ninja,
  sassc,
  nix-update-script,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "amber-theme";
  version = "3.38-1-unstable-2026-10-01";

  src = fetchFromGitHub {
    owner = "lassekongo83";
    repo = "amber-theme";
    rev = "708503ddf3725205ccd810b6a54ef93fdf163d55";
    hash = "sha256-cJ8C4X1pMxgqNlv/afYbsF/i162PI8+6xeInbah8qt8=";
  };

  __structuredAttrs = true;
  strictDeps = true;

  nativeBuildInputs = [
    meson
    ninja
    sassc
  ];

  # The GTK2 themes need gtk-engine-murrine, which is no longer packaged.
  mesonFlags = [ (lib.mesonBool "gtk2" false) ];

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "GTK, gnome-shell and Xfce theme based on Ubuntu Ambiance";
    homepage = "https://github.com/lassekongo83/amber-theme";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ FlorianFranzen ];
  };
})

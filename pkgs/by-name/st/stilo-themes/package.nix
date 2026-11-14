{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  meson,
  ninja,
  sassc,
  fetchpatch2,
  nix-update-script,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "stilo-themes";
  version = "4.0";

  src = fetchFromGitHub {
    owner = "lassekongo83";
    repo = "stilo-themes";
    tag = "v${finalAttrs.version}";
    hash = "sha256-YKEDXrOAn7pGWb0VcOx7cKHnuX120yPzqtUVnzyLrDQ=";
  };

  __structuredAttrs = true;
  strictDeps = true;

  nativeBuildInputs = [
    meson
    ninja
    sassc
  ];

  # Backport the gtk2 option, which is merged upstream but not in a release.
  patches = [
    (fetchpatch2 {
      url = "https://github.com/lassekongo83/stilo-themes/commit/0f9ac3ec6858fe3a9d9c7fc69b2d54eca624d409.patch";
      hash = "sha256-PUk7GghCQBBdV0T5vF3GoAKZY1WD7Oj57R8b0H9VzBc=";
    })
  ];

  # The GTK2 themes need gtk-engine-murrine, which is no longer packaged.
  mesonFlags = [ (lib.mesonBool "gtk2" false) ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Minimalistic GTK, gnome shell and Xfce themes";
    homepage = "https://github.com/lassekongo83/stilo-themes";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ FlorianFranzen ];
  };
})

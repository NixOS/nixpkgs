{
  stdenvNoCC,
  lib,
  fetchFromGitHub,
  nix-update-script,
  meson,
  ninja,
  dart-sass,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "adw-gtk3";
  version = "6.2";

  src = fetchFromGitHub {
    owner = "lassekongo83";
    repo = "adw-gtk3";
    tag = "v${finalAttrs.version}";
    hash = "sha256-YYaqSEnIYHHkY4L3UhFBkR3DehoB6QADhSGOP/9NKx8=";
  };

  nativeBuildInputs = [
    meson
    ninja
    dart-sass
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Unofficial GTK 3 port of libadwaita";
    homepage = "https://github.com/lassekongo83/adw-gtk3";
    license = lib.licenses.lgpl21Only;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [
      ciferkey
      Gliczy
      normalcea
    ];
  };
})

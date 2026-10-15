{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  glib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "adapta-backgrounds";
  version = "0.5.3.1";

  src = fetchFromGitHub {
    owner = "adapta-project";
    repo = "adapta-backgrounds";
    tag = finalAttrs.version;
    hash = "sha256-snnK7CzAO2j0MI0MqmntsBcv6eTD8/tQjDqf5H5dFRI=";
  };

  strictDeps = true;
  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];
  buildInputs = [ glib ];

  meta = {
    description = "Wallpaper collection for adapta-project";
    homepage = "https://github.com/adapta-project/adapta-backgrounds";
    license = with lib.licenses; [
      gpl2
      cc-by-sa-40
    ];
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ romildo ];
  };
})

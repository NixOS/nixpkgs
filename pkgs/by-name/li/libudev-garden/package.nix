{
  lib,
  stdenv,
  fetchFromCodeberg,
  nix-update-script,
  meson,
  ninja,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libudev-garden";
  version = "0.2.1";

  __structuredAttrs = true;

  src = fetchFromCodeberg {
    owner = "Gardenhouse";
    repo = "libudev-garden";
    tag = "v${finalAttrs.version}";
    hash = "sha256-+95+3Hb6lkIhpNZF0pQdM9y5GxZCplp/o2nemZJb5Wc=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://codeberg.org/Gardenhouse/libudev-garden";
    description = "Daemonless replacement for libudev for use with gardendevd";
    maintainers = with lib.maintainers; [
      aanderse
      choco98
    ];
    license = lib.licenses.isc;
    pkgConfigModules = [ "libudev" ];
    platforms = lib.platforms.linux;
    sourceProvenance = [ lib.sourceTypes.fromSource ];
  };
})

{
  cargo,
  meson,
  ninja,
  oo7,
  pkg-config,
  rustPlatform,
  rustc,
  stdenv,
  systemd,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "oo7-portal";
  inherit (oo7) version src cargoDeps;

  sourceRoot = "${finalAttrs.src.name}/portal";
  cargoRoot = "../";

  nativeBuildInputs = [
    pkg-config
    meson
    ninja
    rustPlatform.cargoSetupHook
    rustc
    cargo
  ];

  buildInputs = [
    systemd
  ];

  meta = {
    inherit (oo7.meta)
      homepage
      changelog
      license
      maintainers
      platforms
      ;
    description = "${oo7.meta.description} (XDG Desktop Portal)";
  };
})

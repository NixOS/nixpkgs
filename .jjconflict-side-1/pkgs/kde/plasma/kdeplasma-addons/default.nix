{
  mkKdeDerivation,
  sources,
  rustPlatform,
  rustc,
  cargo,
  pkg-config,
  corrosion,
  qtwebengine,
  hidapi,
}:
mkKdeDerivation rec {
  pname = "kdeplasma-addons";

  inherit (sources.${pname}) version;

  cargoRoot = "kdeds/kameleon/qmk/kameleon-qmk-helper";

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version cargoRoot;
    src = sources.${pname};
    hash = "sha256-HfHiue3hWZc243gYI9VfIi5c30itWhU22+ZEwoy8gPY=";
  };

  extraNativeBuildInputs = [
    rustPlatform.cargoSetupHook
    rustc
    cargo
    pkg-config
  ];

  extraBuildInputs = [
    corrosion
    qtwebengine
    hidapi
  ];
}

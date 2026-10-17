{
  rustPlatform,
  ddccontrol,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "ddccontrol-dbgen";
  inherit (ddccontrol)
    version
    src
    cargoDeps
    meta
    ;

  cargoBuildFlags = [
    "--package"
    "ddccontrol-dbgen"
  ];
})

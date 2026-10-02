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
  __structuredAttrs = true;

  cargoBuildFlags = [
    "--package"
    "ddccontrol-dbgen"
  ];
})

{
  oo7,
  rustPlatform,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "oo7-cargo-credential";
  inherit (oo7) version src cargoDeps;

  buildAndTestSubdir = "cargo-credential";

  strictDeps = true;
  __structuredAttrs = true;

  meta = {
    inherit (oo7.meta)
      homepage
      changelog
      license
      maintainers
      platforms
      ;
    description = "${oo7.meta.description} (cargo-credential helper)";
    mainProgram = "cargo-credential-oo7";
  };
})

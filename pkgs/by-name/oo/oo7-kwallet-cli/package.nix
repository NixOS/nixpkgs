{
  oo7,
  rustPlatform,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "oo7-kwallet-cli";
  inherit (oo7) version src cargoDeps;

  buildAndTestSubdir = "kwallet/cli";

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
    description = "${oo7.meta.description} (kwallet-cli)";
    mainProgram = "kwallet-cli";
  };
})

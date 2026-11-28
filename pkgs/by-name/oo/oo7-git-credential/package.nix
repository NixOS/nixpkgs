{
  oo7,
  rustPlatform,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "oo7-git-credential";
  inherit (oo7) version src cargoDeps;

  buildAndTestSubdir = "git-credential";

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
    description = "${oo7.meta.description} (git-credential helper)";
    mainProgram = "git-credential-oo7";
  };
})

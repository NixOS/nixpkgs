{
  lib,
  rustPlatform,
  fetchFromGitHub,
  testers,
  hex,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "hex";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "sitkevij";
    repo = "hex";
    rev = "v${finalAttrs.version}";
    hash = "sha256-mqBVoaPKk3gG/drvwX+nHOzIXVM53hbkBJRdKk3a6Lo=";
  };

  cargoHash = "sha256-faZTjori9MXzH4jC73G498WI7THFkGdh31fFb/F6fvA=";

  passthru.tests.version = testers.testVersion {
    package = hex;
    version = "hx ${finalAttrs.version}";
  };

  meta = {
    description = "Futuristic take on hexdump, made in Rust";
    homepage = "https://github.com/sitkevij/hex";
    changelog = "https://github.com/sitkevij/hex/releases/tag/v${finalAttrs.version}";
    mainProgram = "hx";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})

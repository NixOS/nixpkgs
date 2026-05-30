{
  lib,
  fetchFromGitHub,
  rustPlatform,
  icu,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "actool";
  version = "2.1.2";

  src = fetchFromGitHub {
    owner = "viraptor";
    repo = "actool";
    tag = finalAttrs.version;
    hash = "sha256-LN35yD9iynU1sCkp5kWL9jUgRIvNTkssherTBaSBenU=";
  };

  cargoHash = "sha256-Fw/0KmFDqXs3IjqnoYfvdrQS3QzF7QhIwmTRt18JEq4=";

  meta = {
    description = "Apple's actool reimplementation";
    homepage = "https://github.com/viraptor/actool";
    license = [ lib.licenses.mit ];
    mainProgram = "actool";
    maintainers = [ lib.maintainers.viraptor ];
  };
})

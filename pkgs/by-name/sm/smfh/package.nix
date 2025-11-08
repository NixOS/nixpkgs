{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "smfh";
  version = "1.2";

  src = fetchFromGitHub {
    owner = "feel-co";
    repo = "smfh";
    tag = finalAttrs.version;
    hash = "sha256-LxLu578DRp1l3ekybZ+g6zNbvt27rOx7wORP9ch5O2c=";
  };

  cargoHash = "sha256-DOE0Bs09TRP7fUqzB0mdylFc1vYsRjcz9chrQG79ajg=";

  meta = {
    description = "Sleek Manifest File Handler";
    homepage = "https://github.com/feel-co/smfh";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [
      arthsmn
      gerg-l
    ];
    mainProgram = "smfh";
  };
})

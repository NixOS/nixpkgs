{
  lib,
  pkg-config,
  openssl,
  rustPlatform,
  fetchFromCodeberg,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "bleur";
  version = "0.0.7";
  __structuredAttrs = true;

  src = fetchFromCodeberg {
    owner = "bleur";
    repo = "bleur";
    tag = "v${finalAttrs.version}";
    hash = "sha256-bFpOvnC2MILr3b+KdVOAvDGmEZM8LDlwGd04csk2l18=";
  };

  cargoHash = "sha256-edeegm0QeXqj0E46+BHcmJMU1Ewn6p9hi3WArDtyVnI=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ];
  strictDeps = true;

  meta = {
    description = "Template manager & buddy for bleur templates by Orzklv";
    platforms = with lib.platforms; linux ++ darwin;
    mainProgram = "bleur";
    homepage = "https://codeberg.org/bleur/bleur";
    license = with lib.licenses; [
      mit
      asl20
    ];
    maintainers = with lib.maintainers; [
      orzklv
      bahrom04
      wolfram444
    ];
  };
})

{
  lib,
  rustPlatform,
  fetchCrate,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "faketty";
  version = "1.0.21";

  src = fetchCrate {
    inherit (finalAttrs) pname version;
    hash = "sha256-IDikuswaa8QZovwoks31hrmsFDtcniiaIddSXrU5pjI=";
  };

  cargoHash = "sha256-D72i5v/sVCC9bBOMmi62IFy9jPMSnmNcYLTyOaANVM0=";

  postPatch = ''
    patchShebangs tests/test.sh
  '';

  meta = {
    description = "Wrapper to execute a command in a pty, even if redirecting the output";
    homepage = "https://github.com/dtolnay/faketty";
    changelog = "https://github.com/dtolnay/faketty/releases/tag/${finalAttrs.version}";
    license =
      with lib.licenses;
      OR [
        asl20
        mit
      ];
    maintainers = with lib.maintainers; [ figsoda ];
    mainProgram = "faketty";
  };
})

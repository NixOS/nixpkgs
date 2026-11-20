{
  lib,
  rustPlatform,
  fetchFromCodeberg,
  stdenv,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "sneakerweb";
  version = "1.2.0";

  src = fetchFromCodeberg {
    owner = "worm-blossom";
    repo = "sneakerweb";
    tag = finalAttrs.version;
    hash = "sha256-Fh3nVoHMJmsbJmG1Ps4u1bNKdbYKrPgF7GhrCOXamVw=";
  };

  cargoHash = "sha256-DC/Oiu/hP1wthBIGA7saUHIhnOQOqiOhBd0G+KWzNqY=";

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  __structuredAttrs = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "A parallel web transported by physical media";
    homepage = "https://sneakerweb.org/";
    license = lib.licenses.OR [
      lib.licenses.asl20
      lib.licenses.mit
    ];
    maintainers = [ lib.maintainers.munksgaard ];
    mainProgram = "sneakerweb";
  };
})

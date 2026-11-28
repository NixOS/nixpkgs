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
  version = "1.3.0";

  src = fetchFromCodeberg {
    owner = "worm-blossom";
    repo = "sneakerweb";
    tag = finalAttrs.version;
    hash = "sha256-mCPh9MmVKGujpYdGXFjvLJUN21r/roByqbTC/JnbWMQ=";
  };

  cargoHash = "sha256-+JaD+0DgVZgORtlz8TIKtOMieQ1W+JKChmDZIW0m/vk=";

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

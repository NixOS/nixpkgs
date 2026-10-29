{
  lib,
  rustPlatform,
  fetchFromCodeberg,
  stdenv,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "sneakerweb";
  version = "1.0.1";

  src = fetchFromCodeberg {
    owner = "worm-blossom";
    repo = "sneakerweb";
    rev = "5b26074b7db7bd5c5200b2ad5263cd79b29134e6";
    hash = "sha256-QufVMRFu/49M39lJYd3ImlvF+cCWYepx7E/mK3957NY=";
  };

  cargoHash = "sha256-6miju3dsKTHlyt+YMJEIP+Ygpm/wQGW4EVCe7iwOi08=";

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  __structuredAttrs = true;

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

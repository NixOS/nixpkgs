{
  fetchFromGitHub,
  rustPlatform,
  lib,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "attest";
  version = "0.5.4";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "fossable";
    repo = "attest";
    tag = "v${finalAttrs.version}";
    hash = "sha256-YRMLz4dv+HOh+JW2ZyeTMDEjBmQi8JsyfwF6+FTYLrU=";
  };

  cargoHash = "sha256-kFbYbga95OLTuAfdmu0Jm7380ib1mXSqPwC3GaJVnq4=";

  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    mainProgram = "attest";
    description = "Dead simple test framework for the age of AI";
    homepage = "https://github.com/fossable/attest";
    license = lib.licenses.unlicense;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ cilki ];
  };
})

{
  lib,
  buildGoModule,
  callPackage,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "roots";
  version = "0.4.1";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "k1LoW";
    repo = "roots";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ACMRfWY/lhc3C/KVhuUyS1rgkSHGWPxZrmYt+pXupJI=";
  };

  vendorHash = "sha256-uxcT5VzlTCxxnx09p13mot0wVbbas/otoHdg7QSDt4E=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/k1LoW/roots/version.Version=${finalAttrs.version}"
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru = {
    updateScript = nix-update-script { };
    tests.monorepo-detection = callPackage ./test.nix { roots = finalAttrs.finalPackage; };
  };

  meta = {
    description = "Tool for exploring multiple root directories such as those in a monorepo project";
    longDescription = ''
      roots discovers root directories of projects (those containing files
      like package.json, go.mod, or Cargo.toml) and prints their paths.
      It is useful for locating each subproject in a monorepo and feeding
      the results into other tools.
    '';
    homepage = "https://github.com/k1LoW/roots";
    changelog = "https://github.com/k1LoW/roots/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    mainProgram = "roots";
    maintainers = with lib.maintainers; [ tnmt ];
  };
})

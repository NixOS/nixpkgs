{
  lib,
  rustPlatform,
  fetchFromGitHub,
  fetchpatch,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "dipc";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "doprz";
    repo = "dipc";
    tag = "v${finalAttrs.version}";
    hash = "sha256-sK4wyrEr1RCdug6uDjFQvMlZzrhPAcXi6yTiiWiPQcc=";
  };

  cargoHash = "sha256-BCJXROjsaztzv6HWi1+i2GYCoeEgdXbYrEjpEdUvGFg=";

  patches = [
    # TODO: Remove it once it goes to the next version (>1.2.0)
    # feat(theme): add Kanagawa theme (#45)
    (fetchpatch {
      name = "kanagawa-theme";
      url = "https://github.com/doprz/dipc/commit/e5a7d851117ccef1250f2a7999ab05dfd9538c53.patch";
      hash = "sha256-OteBFaRT+HdDtWNe5nLaoIgNjapzNOdZfAttOA7G+2E=";
    })
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  meta = {
    description = "Convert your favorite images and wallpapers with your favorite color palettes/themes";
    homepage = "https://github.com/doprz/dipc";
    license = with lib.licenses; [
      mit
      asl20
    ];
    maintainers = with lib.maintainers; [
      doprz
      ByteSudoer
    ];
    mainProgram = "dipc";
  };
})

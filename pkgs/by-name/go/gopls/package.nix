{
  lib,
  # gopls breaks if it is compiled with a lower version than the one it is running against.
  # This will affect users especially when project they work on bump go minor version before
  # the update went through nixpkgs staging. Further, gopls is a central ecosystem component.
  buildGoLatestModule,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:

buildGoLatestModule (finalAttrs: {
  pname = "gopls";
<<<<<<< HEAD
  version = "0.21.0";
=======
  version = "0.20.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "golang";
    repo = "tools";
    tag = "gopls/v${finalAttrs.version}";
<<<<<<< HEAD
    hash = "sha256-fPG8//DWA0mzqZkYasiBdB5hw5FDRkr/3+ZXm7fNHRg=";
  };

  modRoot = "gopls";
  vendorHash = "sha256-9HP+CQiOHoOrcLzzJLRzfpt+I2zJ/AQKtPUqJQwveS8=";
=======
    hash = "sha256-DYYitsrdH4nujDFJgdkObEpgElhXI7Yk2IpA/EVVLVo=";
  };

  modRoot = "gopls";
  vendorHash = "sha256-J6QcefSs4XtnktlzG+/+aY6fqkHGd9MMZqi24jAwcd0=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  # https://github.com/golang/tools/blob/9ed98faa/gopls/main.go#L27-L30
  ldflags = [ "-X main.version=v${finalAttrs.version}" ];

  doCheck = false;

  # Only build gopls & modernize, not the integration tests or documentation generator.
  subPackages = [
    "."
    "internal/analysis/modernize/cmd/modernize"
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "version";

  passthru.updateScript = nix-update-script { extraArgs = [ "--version-regex=gopls/(.*)" ]; };

  meta = {
    changelog = "https://github.com/golang/tools/releases/tag/gopls/v${finalAttrs.version}";
    description = "Official language server for the Go language";
    homepage = "https://github.com/golang/tools/tree/master/gopls";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [
      mic92
      rski
      SuperSandro2000
      zimbatm
    ];
    mainProgram = "gopls";
  };
})

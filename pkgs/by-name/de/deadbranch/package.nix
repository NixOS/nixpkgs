{
  lib,
  rustPlatform,
  fetchFromGitHub,

  # nativeBuildInputs
  installShellFiles,

  # nativeCheckInputs
  gitMinimal,
  writableTmpDirAsHomeHook,

  # nativeInstallCheckInputs
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "deadbranch";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "armgabrielyan";
    repo = "deadbranch";
    tag = "v${finalAttrs.version}";
    hash = "sha256-8KNo/6hdeBY8RbLlXt2gpLCk2DfvSuoeXJ0oh2NDX2s=";
  };

  cargoHash = "sha256-iY39RBA0fl/BpX6mlCH2bHuN+XsLdq4f7CTzjHz9Ots=";

  nativeBuildInputs = [ installShellFiles ];

  nativeCheckInputs = [
    gitMinimal
    writableTmpDirAsHomeHook
  ];

  postInstall = ''
    installManPage $releaseDir/build/deadbranch-*/out/deadbranch.1
    installShellCompletion --cmd deadbranch \
      --bash <($out/bin/deadbranch completions bash) \
      --fish <($out/bin/deadbranch completions fish) \
      --zsh <($out/bin/deadbranch completions zsh)
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  meta = {
    description = "Clean up stale git branches safely";
    homepage = "https://github.com/armgabrielyan/deadbranch";
    license = lib.licenses.mit;
    mainProgram = "deadbranch";
    maintainers = with lib.maintainers; [ mahyarmirrashed ];
  };
})

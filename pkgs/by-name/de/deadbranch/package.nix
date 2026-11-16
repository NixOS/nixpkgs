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
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "armgabrielyan";
    repo = "deadbranch";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ub06sn3CUlbU9LkDCbZJmoZ7CQef97HeXhRdW6ESw1U=";
  };

  cargoHash = "sha256-9AhTTvSv0HGQxglifmcEU0ApZuCIng7gFgfCMQLXpLo=";

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

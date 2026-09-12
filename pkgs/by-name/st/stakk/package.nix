{
  stdenv,
  lib,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "stakk";
  version = "2.5.0";

  src = fetchFromGitHub {
    owner = "glennib";
    repo = "stakk";
    tag = "v${finalAttrs.version}";
    hash = "sha256-4P1ZAwmpt9OJPz9h5DYEFWtWlLyxMXQI53T+1lP82X4=";
  };

  cargoHash = "sha256-ycQc9I2sYmchBK8hQAJCkB/GFSNUBp+/qX9Kt5tPPLY=";

  useNextest = true;

  doInstallCheck = true;
  nativeInstallCheckInputs = [
    installShellFiles
    versionCheckHook
  ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd stakk \
      --bash <($out/bin/stakk completions bash) \
      --fish <($out/bin/stakk completions fish) \
      --zsh <($out/bin/stakk completions zsh) \
  '';

  passthru.updateScript = nix-update-script { };
  __structuredAttrs = true;

  meta = {
    description = "Bridge Jujutsu (jj) bookmarks to GitHub stacked pull requests";
    homepage = "https://github.com/glennib/stakk";
    changelog = "https://github.com/glennib/stakk/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = with lib.maintainers; [
      voidlily
      Br1ght0ne
    ];
    mainProgram = "stakk";
  };
})

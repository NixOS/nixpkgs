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
  version = "2.6.0";

  src = fetchFromGitHub {
    owner = "glennib";
    repo = "stakk";
    tag = "v${finalAttrs.version}";
    hash = "sha256-bwk+Dwcf0QspJMk9fRFIHDIOaWuXib33ag/H0oqtZQ8=";
  };

  cargoHash = "sha256-wIw2jWa+warQpMTPFYbKVHZal3qtam6H3TJRkvj+09Q=";

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

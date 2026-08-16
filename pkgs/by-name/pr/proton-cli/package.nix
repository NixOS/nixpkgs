{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  pkg-config,
  stdenv,
  webkitgtk_4_1,
  gtk3,
  nix-update-script,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "proton-cli";
  version = "2.4.1";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "roman-16";
    repo = "proton-cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Kb7/KpTXJzbsBkF0SLqeF35dE6N693X9+hyDpSqreaE=";
  };

  vendorHash = "sha256-VjLuSaHW7C1Ar84vusMRjBWVikgVCdLBwd+OFT7ufiQ=";

  subPackages = [ "cmd/proton" ];

  tags = [ "embed_hv" ];

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/roman-16/proton-cli/internal/cli.version=${finalAttrs.version}"
  ];

  nativeBuildInputs = [
    installShellFiles
    pkg-config
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    webkitgtk_4_1
    gtk3
  ];

  preBuild = ''
    bash scripts/build-hv-helpers.sh
  '';

  overrideModAttrs = _: {
    preBuild = null;
  };

  postInstall = ''
    ln -s proton $out/bin/proton-cli
    installShellCompletion --cmd proton \
      --bash <($out/bin/proton completion bash) \
      --fish <($out/bin/proton completion fish) \
      --zsh  <($out/bin/proton completion zsh)
    installShellCompletion --cmd proton-cli \
      --bash <($out/bin/proton completion bash) \
      --fish <(echo 'complete -c proton-cli -w proton')
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Unofficial command-line client for the Proton suite (Mail, Drive, Calendar, Contacts, Pass)";
    homepage = "https://github.com/roman-16/proton-cli";
    changelog = "https://github.com/roman-16/proton-cli/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    mainProgram = "proton";
    maintainers = with lib.maintainers; [ roman-16 ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})

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
  testers,
  proton-cli,
}:

buildGoModule (finalAttrs: {
  pname = "proton-cli";
  version = "1.4.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "roman-16";
    repo = "proton-cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-JZ6Lr7mcL8sHeiptdB1CPv5zPaLsMKfUXd/KCf1tTDM=";
  };

  vendorHash = "sha256-1p63FiV9lFquADaV0/mhxdWhefBRY1IT91t7OdEH9BM=";

  subPackages = [ "." ];

  tags = [ "embed_hv" ];

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/roman-16/proton-cli/cmd.version=${finalAttrs.version}"
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
    installShellCompletion --cmd proton-cli \
      --bash <($out/bin/proton-cli completion bash) \
      --fish <($out/bin/proton-cli completion fish) \
      --zsh  <($out/bin/proton-cli completion zsh)
  '';

  passthru = {
    tests.version = testers.testVersion {
      package = proton-cli;
      command = "proton-cli --version";
      version = finalAttrs.version;
    };
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Unofficial command-line client for the Proton suite (Mail, Drive, Calendar, Contacts, Pass)";
    homepage = "https://github.com/roman-16/proton-cli";
    changelog = "https://github.com/roman-16/proton-cli/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    mainProgram = "proton-cli";
    maintainers = with lib.maintainers; [ roman-16 ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})

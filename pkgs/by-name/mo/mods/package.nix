{
  lib,
  stdenv,
  buildGoModule,
  installShellFiles,
  fetchFromGitHub,
  gitUpdater,
  testers,
  mods,
  installShellCompletions ? stdenv.buildPlatform.canExecute stdenv.hostPlatform,
  installManPages ? stdenv.buildPlatform.canExecute stdenv.hostPlatform,
}:

buildGoModule (finalAttrs: {
  pname = "mods";
  version = "1.7.0";

  src = fetchFromGitHub {
    owner = "charmbracelet";
    repo = "mods";
    tag = "v${finalAttrs.version}";
    hash = "sha256-wzLYkcgUWPzghJEhYRh7HH19Rqov1RJAxdgp3AGnOTY=";
  };

  vendorHash = "sha256-L+4vkh7u6uMm5ICMk8ke5RVY1oYeKMYWVYYq9YqpKiw=";

  nativeBuildInputs = lib.optionals (installManPages || installShellCompletions) [
    installShellFiles
  ];

  ldflags = [
    "-s"
    "-w"
    "-X=main.Version=${finalAttrs.version}"
  ];

  # These tests require internet access.
  checkFlags = [ "-skip=^TestLoad/http_url$|^TestLoad/https_url$" ];

  passthru = {
    updateScript = gitUpdater {
      rev-prefix = "v";
      ignoredVersions = ".(rc|beta).*";
    };

    tests.version = testers.testVersion {
      package = mods;
      command = "HOME=$(mktemp -d) mods -v";
    };
  };

  postInstall = ''
    export HOME=$(mktemp -d)
  ''
  + lib.optionalString installManPages ''
    $out/bin/mods man > ./mods.1
    installManPage ./mods.1
  ''
  + lib.optionalString installShellCompletions ''
    installShellCompletion --cmd mods \
      --bash <($out/bin/mods completion bash) \
      --fish <($out/bin/mods completion fish) \
      --zsh <($out/bin/mods completion zsh)
  '';

  meta = {
    description = "AI on the command line";
    homepage = "https://github.com/charmbracelet/mods";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      dit7ya
      caarlos0
      delafthi
    ];
    mainProgram = "mods";
  };
})

{
  lib,
  buildGoModule,
  fetchFromGitLab,
  installShellFiles,
  makeBinaryWrapper,
  stdenv,
  nix-update-script,
  writableTmpDirAsHomeHook,
  versionCheckHook,
  gitMinimal,
}:

buildGoModule (finalAttrs: {
  pname = "glab";
  version = "1.68.0";

  src = fetchFromGitLab {
    owner = "gitlab-org";
    repo = "cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-KSjgnoUwzHtRZtSUdWSDathmQgJdrtGhb7JR200NYIk=";
    leaveDotGit = true;
    postFetch = ''
      cd "$out"
      git rev-parse --short HEAD > $out/COMMIT
      find "$out" -name .git -print0 | xargs -0 rm -rf
    '';
  };

  vendorHash = "sha256-rt7HATHyaHufAPJ3fcrukrKOvFBeqpTCq7j+qKlHFbo=";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${finalAttrs.version}"
  ];

  preBuild = ''
    ldflags+=" -X main.commit=$(cat COMMIT)"
  '';

  nativeBuildInputs = [
    installShellFiles
    makeBinaryWrapper
  ];

  subPackages = [ "cmd/glab" ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    make manpage
    installManPage share/man/man1/*
    installShellCompletion --cmd glab \
      --bash <($out/bin/glab completion -s bash) \
      --fish <($out/bin/glab completion -s fish) \
      --zsh <($out/bin/glab completion -s zsh)

    wrapProgram $out/bin/glab \
      --set-default GLAB_CHECK_UPDATE 0 \
      --set-default GLAB_SEND_TELEMETRY 0
  '';

  nativeCheckInputs = [ writableTmpDirAsHomeHook ];

  preCheck = ''
    git init
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [
    gitMinimal
    versionCheckHook
    writableTmpDirAsHomeHook
  ];
  versionCheckProgramArg = "version";
  versionCheckKeepEnvironment = [ "HOME" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "GitLab CLI tool bringing GitLab to your command line";
    license = lib.licenses.mit;
    homepage = "https://gitlab.com/gitlab-org/cli";
    changelog = "https://gitlab.com/gitlab-org/cli/-/releases/v${finalAttrs.version}";
    maintainers = with lib.maintainers; [
      freezeboy
      luftmensch-luftmensch
      anthonyroussel
    ];
    mainProgram = "glab";
  };
})

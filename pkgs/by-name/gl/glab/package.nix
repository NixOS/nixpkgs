{
  lib,
  buildGoModule,
  fetchFromGitLab,
  installShellFiles,
  stdenv,
  nix-update-script,
  writableTmpDirAsHomeHook,
}:

buildGoModule (finalAttrs: {
  pname = "glab";
  version = "1.56.0";

  src = fetchFromGitLab {
    owner = "gitlab-org";
    repo = "cli";
    rev = "v${finalAttrs.version}";
    hash = "sha256-sLxb3BC2yvtbT11C9iWlGsIQ/7Lr34+q/BPIcDx4P+s=";
    leaveDotGit = true;
    postFetch = ''
      cd "$out"
      git rev-parse --short HEAD > $out/COMMIT
      find "$out" -name .git -print0 | xargs -0 rm -rf
    '';
  };

  vendorHash = "sha256-m4IWtK2PNjs2UxzVCT2oSx6Gic2flN4Fq8w0mNIhHxo=";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${finalAttrs.version}"
  ];

  preBuild = ''
    ldflags+=" -X main.commit=$(cat COMMIT)"
  '';


  subPackages = [ "cmd/glab" ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    make manpage
    installManPage share/man/man1/*
    installShellCompletion --cmd glab \
      --bash <($out/bin/glab completion -s bash) \
      --fish <($out/bin/glab completion -s fish) \
      --zsh <($out/bin/glab completion -s zsh)
  '';

  nativeCheckInputs = [ writableTmpDirAsHomeHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "GitLab CLI tool bringing GitLab to your command line";
    license = lib.licenses.mit;
    homepage = "https://gitlab.com/gitlab-org/cli";
    changelog = "https://gitlab.com/gitlab-org/cli/-/releases/v${finalAttrs.version}";
    maintainers = with lib.maintainers; [
      freezeboy
      luftmensch-luftmensch
    ];
    mainProgram = "glab";
  };
})

{
  lib,
  stdenv,
  buildGo124Module,
  fetchFromGitHub,
  git,
  nix-update-script,
  installShellFiles,
}:

buildGo124Module rec {
  pname = "git-spice";
  version = "0.15.2";

  src = fetchFromGitHub {
    owner = "abhinav";
    repo = "git-spice";
    tag = "v${version}";
    hash = "sha256-vpBQdkP5jC3glGykLCd3/df4Lhi0MeU0XLnlTNDp1bM=";
  };

  vendorHash = "sha256-uh4GUkfWo12pYQD/Mpw+EWwmukHUpxOii7DTu6C84zo=";

  subPackages = [ "." ];

  nativeBuildInputs = [ installShellFiles ];

  nativeCheckInputs = [ git ];

  buildInputs = [ git ];

  ldflags = [
    "-s"
    "-w"
    "-X=main._version=${version}"
  ];

  __darwinAllowLocalNetworking = true;

  preCheck = ''
    # timeout on both aarch64-darwin and x86_64-linux
    rm testdata/script/issue725_pre_push_hook_worktree.txt

    # failing on both aarch64-darwin and x86_64-linux
    # TODO: check if this still fails after next release
    rm testdata/script/branch_restack_conflict_no_edit.txt
  ''

  + lib.optionalString (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isx86_64) ''
    # timeout
    rm testdata/script/branch_submit_remote_prompt.txt
    rm testdata/script/branch_submit_multiple_pr_templates.txt
  '';

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd gs \
      --bash <($out/bin/gs shell completion bash) \
      --zsh <($out/bin/gs shell completion zsh) \
      --fish <($out/bin/gs shell completion fish)
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Manage stacked Git branches";
    homepage = "https://abhinav.github.io/git-spice/";
    changelog = "https://github.com/abhinav/git-spice/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.gpl3Only;
    maintainers = [ lib.maintainers.vinnymeller ];
    mainProgram = "gs";
  };
}

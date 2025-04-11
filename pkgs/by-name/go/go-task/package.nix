{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  nix-update-script,
  versionCheckHook,
  fetchpatch2,
}:

buildGoModule rec {
  pname = "go-task";
  version = "3.42.1";

  src = fetchFromGitHub {
    owner = "go-task";
    repo = "task";
    tag = "v${version}";
    hash = "sha256-oA/vW4TWLePOW26xOguiAOcVxx6J2PiJFelOM0mDYBA=";
  };

  vendorHash = "sha256-BmpyPWCgVpx5KWET/VUYkxKE7Rni9Rnsqk5skxlxrqA=";

  nativeBuildInputs = [ installShellFiles ];

  subPackages = [ "cmd/task" ];

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/go-task/task/v3/internal/version.version=${version}"
  ];

  patches = [
    # Workaround to avoid empty version number. Consider removing after release 3.42.2 or later.
    # This patch was suggested in https://github.com/go-task/task/pull/2105 and is still used in the Homebrew formula.
    # Although that PR was closed by merging https://github.com/go-task/task/pull/2131 upstream,
    # the commit depends on other unreleased changes.
    (fetchpatch2 {
      url = "https://github.com/go-task/task/commit/44cb98cb0620ea98c43d0f11ce92f5692ad57212.patch?full_index=1";
      hash = "sha256-LCaDarCeKs7fZ70DjlKdGAjRZpE5mASbhAxCbhtc5nI=";
    })
  ];

  env.CGO_ENABLED = 0;

  postInstall =
    ''
      ln -s $out/bin/task $out/bin/go-task
    ''
    + lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
      installShellCompletion --cmd task \
        --bash <($out/bin/task --completion bash) \
        --fish <($out/bin/task --completion fish) \
        --zsh <($out/bin/task --completion zsh)
    '';

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;
  versionCheckProgram = "${placeholder "out"}/bin/task";
  versionCheckProgramArg = "--version";

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    homepage = "https://taskfile.dev/";
    description = "Task runner / simpler Make alternative written in Go";
    changelog = "https://github.com/go-task/task/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ parasrah ];
  };
}

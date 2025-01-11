{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  testers,
  nix-update-script,
  go-task,
}:

buildGoModule rec {
  pname = "go-task";
  version = "3.40.1";

  src = fetchFromGitHub {
    owner = "go-task";
    repo = "task";
    tag = "v${version}";
    hash = "sha256-jQKPTKEzTfzqPlNlKFMduaAhvDsogRv3vCGtZ4KP/O4=";
  };

  vendorHash = "sha256-bw9NaJOMMKcKth0hRqNq8mqib/5zLpjComo0oj22A/U=";

  doCheck = false;

  nativeBuildInputs = [ installShellFiles ];

  subPackages = [ "cmd/task" ];

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/go-task/task/v3/internal/version.version=${version}"
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

  passthru = {
    tests = {
      version = testers.testVersion {
        package = go-task;
      };
    };

    updateScript = nix-update-script { };
  };

  meta = with lib; {
    homepage = "https://taskfile.dev/";
    description = "Task runner / simpler Make alternative written in Go";
    changelog = "https://github.com/go-task/task/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ parasrah ];
  };
}

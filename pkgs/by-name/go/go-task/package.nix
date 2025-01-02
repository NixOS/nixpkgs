{ lib
, buildGoModule
, fetchFromGitHub
, installShellFiles
, testers
, nix-update-script
, go-task
}:

buildGoModule rec {
  pname = "go-task";
  version = "3.40.1";

  src = fetchFromGitHub {
    owner = "go-task";
    repo = "task";
    rev = "refs/tags/v${version}";
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

  postInstall = ''
    ln -s $out/bin/task $out/bin/go-task

    installShellCompletion completion/{bash,fish,zsh}/*

    substituteInPlace $out/share/bash-completion/completions/task.bash \
      --replace-fail 'complete -F _task task' 'complete -F _task task go-task'
    substituteInPlace $out/share/fish/vendor_completions.d/task.fish \
      --replace-fail 'complete -c $GO_TASK_PROGNAME' 'complete -c $GO_TASK_PROGNAME -c go-task'
    substituteInPlace $out/share/zsh/site-functions/_task \
      --replace-fail '#compdef task' '#compdef task go-task'
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

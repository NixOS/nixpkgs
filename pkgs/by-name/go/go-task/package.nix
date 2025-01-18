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
  version = "3.41.0";

  src = fetchFromGitHub {
    owner = "go-task";
    repo = "task";
    tag = "v${version}";
    hash = "sha256-yJ9XTCS0BK+pcQvcbGR2ixwPODJKdfQnHgB1QoTFhzA=";
  };

  vendorHash = "sha256-DR9G+I6PYk8jrR0CZiPqtuULTMekATNSLjyHACOmlbk=";

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

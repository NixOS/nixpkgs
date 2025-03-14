{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "kfilt";
  version = "0.0.8";

  src = fetchFromGitHub {
    owner = "ryane";
    repo = "kfilt";
    rev = "v${version}";
    hash = "sha256-TUhZKf4fJyJF/qDmvs4jqAMVTXN4MXE+YLc4FcOVlwo=";
  };

  vendorHash = "sha256-c77CzpE9cPyobt87uO0QlkKD+xC/tM7wOy4orM62tnI=";

  subPackages = [ "." ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/ryane/kfilt/cmd.Version=${version}"
    "-X github.com/ryane/kfilt/cmd.GitCommit=${src.rev}"
  ];

  meta = {
    description = "Command-line tool that filters Kubernetes resources";
    mainProgram = "kfilt";
    homepage = "https://github.com/ryane/kfilt";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.ryane ];
  };
}

{ lib, fetchFromGitHub, buildGoModule, installShellFiles }:

buildGoModule rec {
  pname = "orchard";
  version = "0.23.2";

  src = fetchFromGitHub {
    owner = "cirruslabs";
    repo = pname;
    rev = version;
    hash = "sha256-hsYIIA2JA+LT+qaootOkHVN4JD+msO1grYQq4Z6ipYU=";
    # populate values that require us to use git. By doing this in postFetch we
    # can delete .git afterwards and maintain better reproducibility of the src.
    leaveDotGit = true;
    postFetch = ''
      cd "$out"
      git rev-parse HEAD > $out/COMMIT
      find "$out" -name .git -print0 | xargs -0 rm -rf
    '';
  };

  vendorHash = "sha256-HphNpli6hYvmeIJlkkSzOZDbdqFL4XI+koUK9RvWfw8=";

  nativeBuildInputs = [ installShellFiles ];

  ldflags = [
    "-w"
    "-s"
    "-X github.com/cirruslabs/orchard/internal/version.Version=${version}"
  ];

  # ldflags based on metadata from git and source
  preBuild = ''
    ldflags+=" -X github.com/cirruslabs/orchard/internal/version.Commit=$(cat COMMIT)"
  '';

  subPackages = [ "cmd/orchard" ];

  postInstall = ''
    export HOME="$(mktemp -d)"
    installShellCompletion --cmd orchard \
      --bash <($out/bin/orchard completion bash) \
      --zsh <($out/bin/orchard completion zsh) \
      --fish <($out/bin/orchard completion fish)
  '';

  meta = with lib; {
    mainProgram = "orchard";
    description =
      "Orchestrator for running Tart Virtual Machines on a cluster of Apple Silicon devices";
    homepage = "https://github.com/cirruslabs/orchard";
    license = licenses.fairsource09;
    maintainers = with maintainers; [ techknowlogick ];
  };
}

{
  lib,
  stdenv,
  fetchFromGitHub,
  buildGoModule,
  installShellFiles,
}:

buildGoModule rec {
  pname = "orchard";
<<<<<<< HEAD
  version = "0.46.0";
=======
  version = "0.45.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "cirruslabs";
    repo = "orchard";
    rev = version;
<<<<<<< HEAD
    hash = "sha256-fjPaCgHf2cZ24DXc8pNxaD8wOQWs6KWuBE57a9YxdZw=";
=======
    hash = "sha256-4kWpMN92DWwWE53e9oZ4++MH1LI9327YFNqCBm9ZXGQ=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    # populate values that require us to use git. By doing this in postFetch we
    # can delete .git afterwards and maintain better reproducibility of the src.
    leaveDotGit = true;
    postFetch = ''
      cd "$out"
      git rev-parse HEAD > $out/COMMIT
      find "$out" -name .git -print0 | xargs -0 rm -rf
    '';
  };

<<<<<<< HEAD
  vendorHash = "sha256-vRvRWYbDpZ6WJlCJqZOCOprypymfrddv3UC1uDL3J48=";
=======
  vendorHash = "sha256-qjOWsvG3qldBkYso0M71ZeciiUQK7I9wA56zBt+kIRk=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

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

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    export HOME="$(mktemp -d)"
    installShellCompletion --cmd orchard \
      --bash <($out/bin/orchard completion bash) \
      --zsh <($out/bin/orchard completion zsh) \
      --fish <($out/bin/orchard completion fish)
  '';

<<<<<<< HEAD
  meta = {
    mainProgram = "orchard";
    description = "Orchestrator for running Tart Virtual Machines on a cluster of Apple Silicon devices";
    homepage = "https://github.com/cirruslabs/orchard";
    license = lib.licenses.fairsource09;
    maintainers = with lib.maintainers; [ techknowlogick ];
=======
  meta = with lib; {
    mainProgram = "orchard";
    description = "Orchestrator for running Tart Virtual Machines on a cluster of Apple Silicon devices";
    homepage = "https://github.com/cirruslabs/orchard";
    license = licenses.fairsource09;
    maintainers = with maintainers; [ techknowlogick ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}

{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule rec {
  pname = "starboard";
  version = "0.15.20";

  src = fetchFromGitHub {
    owner = "aquasecurity";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-oOz7Dt+j2EmBL/aJUjqRST90wYpXkyREnKCcmNBQX18=";
    # populate values that require us to use git. By doing this in postFetch we
    # can delete .git afterwards and maintain better reproducibility of the src.
    leaveDotGit = true;
    postFetch = ''
      cd "$out"
      git rev-parse HEAD > $out/COMMIT
      # 0000-00-00T00:00:00Z
      date -u -d "@$(git log -1 --pretty=%ct)" "+%Y-%m-%dT%H:%M:%SZ" > $out/SOURCE_DATE_EPOCH
      find "$out" -name .git -print0 | xargs -0 rm -rf
    '';
  };
  vendorHash = "sha256-6qz0nFqdo/ympxuJDy2gD4kr5G5j0DbhUxl+7ocDdO4=";

  nativeBuildInputs = [ installShellFiles ];

  subPackages = [ "cmd/starboard" ];

  ldflags = [
    "-s"
    "-w"
    "-X main.version=v${version}"
  ];

  # ldflags based on metadata from git and source
  preBuild = ''
    ldflags+=" -X main.gitCommit=$(cat COMMIT)"
    ldflags+=" -X main.buildDate=$(cat SOURCE_DATE_EPOCH)"
  '';

  preCheck = ''
    # Remove test that requires networking
    rm pkg/plugin/aqua/client/client_integration_test.go

    # Feed in all but the integration tests for testing
    # This is because subPackages above limits what is built to just what we
    # want but also limits the tests
    getGoDirs() {
      go list ./... | grep -v itest
    }
  '';

  postInstall = ''
    installShellCompletion --cmd starboard \
      --bash <($out/bin/starboard completion bash) \
      --fish <($out/bin/starboard completion fish) \
      --zsh <($out/bin/starboard completion zsh)
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck
    $out/bin/starboard --help
    $out/bin/starboard version | grep "v${version}"
    runHook postInstallCheck
  '';

  meta = with lib; {
    homepage = "https://github.com/aquasecurity/starboard";
    changelog = "https://github.com/aquasecurity/starboard/releases/tag/v${version}";
    description = "Kubernetes-native security tool kit";
    mainProgram = "starboard";
    longDescription = ''
      Starboard integrates security tools into the Kubernetes environment, so
      that users can find and view the risks that relate to different resources
      in a Kubernetes-native way. Starboard provides custom security resources
      definitions and a Go module to work with a range of existing security
      tools, as well as a kubectl-compatible command-line tool and an Octant
      plug-in that make security reports available through familiar Kubernetes
      tools.
    '';
    license = licenses.asl20;
    maintainers = with maintainers; [ jk ];
  };
}

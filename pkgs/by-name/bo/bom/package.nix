{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule rec {
  pname = "bom";
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "kubernetes-sigs";
    repo = "bom";
    tag = "v${version}";
    hash = "sha256-OLbzk1Ix8N2R+od3NQg0JviEcnw6Sw1+wrak26ZWYFw=";
    # populate values that require us to use git. By doing this in postFetch we
    # can delete .git afterwards and maintain better reproducibility of the src.
    leaveDotGit = true;
    postFetch = ''
      cd "$out"
      git rev-parse HEAD > $out/COMMIT
      # '0000-00-00T00:00:00Z'
      date -u -d "@$(git log -1 --pretty=%ct)" "+'%Y-%m-%dT%H:%M:%SZ'" > $out/SOURCE_DATE_EPOCH
      find "$out" -name .git -print0 | xargs -0 rm -rf
    '';
  };

  vendorHash = "sha256-gHlrpseovxAv+YdHipUwuIhUDoK05oizMfUpQTHqi6M=";

  nativeBuildInputs = [ installShellFiles ];

  ldflags = [
    "-s"
    "-w"
    "-X sigs.k8s.io/release-utils/version.gitVersion=v${version}"
    "-X sigs.k8s.io/release-utils/version.gitTreeState=clean"
  ];

  # ldflags based on metadata from git and source
  preBuild = ''
    ldflags+=" -X sigs.k8s.io/release-utils/version.gitCommit=$(cat COMMIT)"
    ldflags+=" -X sigs.k8s.io/release-utils/version.buildDate=$(cat SOURCE_DATE_EPOCH)"
  '';

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd bom \
      --bash <($out/bin/bom completion bash) \
      --fish <($out/bin/bom completion fish) \
      --zsh <($out/bin/bom completion zsh)
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck
    $out/bin/bom --help
    $out/bin/bom version 2>&1 | grep "v${version}"
    runHook postInstallCheck
  '';

  doCheck = false;

  meta = {
    homepage = "https://github.com/kubernetes-sigs/bom";
    changelog = "https://github.com/kubernetes-sigs/bom/releases/tag/v${version}";
    description = "Utility to generate SPDX-compliant Bill of Materials manifests";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ developer-guy ];
    mainProgram = "bom";
  };
}

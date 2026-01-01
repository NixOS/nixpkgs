{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

let
  config-module = "github.com/f1bonacc1/process-compose/src/config";
in
buildGoModule (finalAttrs: {
  pname = "process-compose";
<<<<<<< HEAD
  version = "1.85.0";
=======
  version = "1.78.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "F1bonacc1";
    repo = "process-compose";
    tag = "v${finalAttrs.version}";
<<<<<<< HEAD
    hash = "sha256-8nNvlTl4qUtlNV2ebsObssYRPepPL//fe26y/wY93l4=";
=======
    hash = "sha256-phWrEqDdyXYvxWhToV8j01nDeX9ZV12DichiYDOPaLw=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

    # populate values that require us to use git. By doing this in postFetch we
    # can delete .git afterwards and maintain better reproducibility of the src.
    leaveDotGit = true;
    postFetch = ''
      cd "$out"
      git rev-parse --short HEAD > $out/COMMIT
      # in format of 0000-00-00T00:00:00Z
      date -u -d "@$(git log -1 --pretty=%ct)" "+%Y-%m-%dT%H:%M:%SZ" > $out/SOURCE_DATE_EPOCH
      find "$out" -name .git -print0 | xargs -0 rm -rf
    '';
  };

  # ldflags based on metadata from git and source
  preBuild = ''
    ldflags+=" -X ${config-module}.Commit=$(cat COMMIT)"
    ldflags+=" -X ${config-module}.Date=$(cat SOURCE_DATE_EPOCH)"
  '';

  ldflags = [
    "-X ${config-module}.Version=v${finalAttrs.version}"
    "-s"
    "-w"
  ];

  nativeBuildInputs = [
    installShellFiles
  ];

<<<<<<< HEAD
  vendorHash = "sha256-uZFwiYTkx9TE6T0UJ+EUF8zqP4/8vWYoN+frD6KvQC0=";
=======
  vendorHash = "sha256-TsfZtq8L/FD0DsOW4T2i8BSYNq4jvqLJyOSPdrWGPq8=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  doCheck = false;

  postInstall = ''
<<<<<<< HEAD
=======
    mv $out/bin/{src,process-compose}

>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    installShellCompletion --cmd process-compose \
      --bash <($out/bin/process-compose completion bash) \
      --zsh <($out/bin/process-compose completion zsh) \
      --fish <($out/bin/process-compose completion fish)
  '';

  meta = {
    description = "Simple and flexible scheduler and orchestrator to manage non-containerized applications";
    homepage = "https://github.com/F1bonacc1/process-compose";
    changelog = "https://github.com/F1bonacc1/process-compose/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ thenonameguy ];
    mainProgram = "process-compose";
  };
})

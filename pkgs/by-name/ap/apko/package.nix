{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  writableTmpDirAsHomeHook,
  installShellFiles,
  versionCheckHook,
  buildPackages,
}:

buildGoModule (finalAttrs: {
  pname = "apko";
  version = "0.29.1";

  src = fetchFromGitHub {
    owner = "chainguard-dev";
    repo = "apko";
    tag = "v${finalAttrs.version}";
    hash = "sha256-PRT29c7WqjkWR4hqzzz8ek5IytsS3ntDlPQ/tzpARCk=";
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
  vendorHash = "sha256-j7f9cbcbX4PdaRxg5lare6aRz1B5lCfj2RSvs+XOfe4=";

  nativeBuildInputs = [ installShellFiles ];

  ldflags = [
    "-s"
    "-w"
    "-X sigs.k8s.io/release-utils/version.gitVersion=v${finalAttrs.version}"
    "-X sigs.k8s.io/release-utils/version.gitTreeState=clean"
  ];

  # ldflags based on metadata from git and source
  preBuild = ''
    ldflags+=" -X sigs.k8s.io/release-utils/version.gitCommit=$(cat COMMIT)"
    ldflags+=" -X sigs.k8s.io/release-utils/version.buildDate=$(cat SOURCE_DATE_EPOCH)"
  '';

  nativeCheckInputs = [ writableTmpDirAsHomeHook ];

  # skip tests on darwin due to some local networking failures
  # `__darwinAllowLocalNetworking = true;` wasn't sufficient for
  # aarch64 or x86_64
  doCheck = !stdenv.isDarwin;
  preCheck = ''
    # some test data include SOURCE_DATE_EPOCH (which is different from our default)
    # and the default version info which we get by unsetting our ldflags
    export SOURCE_DATE_EPOCH=0
    unset ldflags
  '';

  checkFlags = [
    # requires networking (apk.chainreg.biz)
    "-skip=TestInitDB_ChainguardDiscovery"
  ];

  postInstall =
    let
      apko =
        if stdenv.buildPlatform.canExecute stdenv.hostPlatform then
          placeholder "out"
        else
          buildPackages.apko;
    in
    ''
      installShellCompletion --cmd apko \
        --bash <(${apko}/bin/apko completion bash) \
        --fish <(${apko}/bin/apko completion fish) \
        --zsh <(${apko}/bin/apko completion zsh)
    '';

  nativeCheckInstallInputs = [ versionCheckHook ];
  doInstallCheck = true;
  versionCheckProgramArg = "version";

  meta = {
    homepage = "https://apko.dev/";
    changelog = "https://github.com/chainguard-dev/apko/blob/main/NEWS.md";
    description = "Build OCI images using APK directly without Dockerfile";
    mainProgram = "apko";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      jk
      developer-guy
      emilylange
    ];
  };
})

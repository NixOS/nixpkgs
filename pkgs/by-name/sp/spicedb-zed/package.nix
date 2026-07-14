{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule (finalAttrs: {
  pname = "zed";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "authzed";
    repo = "zed";
    tag = "v${finalAttrs.version}";
    hash = "sha256-rlTcC2+faNZKvzouGC9nJBBCsDabxozTE/SFbf8YKQ8=";
  };

  vendorHash = "sha256-/nnPVy+pjcgkgJW8630IycmGF4Qq4I01htEDlsWvZbM=";

  ldflags = [ "-X 'github.com/jzelinskie/cobrautil/v2.Version=${finalAttrs.src.tag}'" ];

  # Version test expects '(devel)' but version is being set to the package version
  checkFlags = [ "--skip=TestGetClientVersion" ];

  preCheck = ''
    export NO_COLOR=true
  '';

  nativeBuildInputs = [ installShellFiles ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd zed \
      --bash <($out/bin/zed completion bash) \
      --fish <($out/bin/zed completion fish) \
      --zsh <($out/bin/zed completion zsh)
  '';

  meta = {
    changelog = "https://github.com/authzed/zed/releases/tag/${finalAttrs.src.tag}";
    description = "Command line for managing SpiceDB";
    mainProgram = "zed";
    longDescription = ''
      SpiceDB is an open-source permissions database inspired by
      Google Zanzibar. zed is the command line client for SpiceDB.
    '';
    homepage = "https://authzed.com/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      squat
      thoughtpolice
    ];
  };
})

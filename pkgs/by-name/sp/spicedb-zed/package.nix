{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule rec {
  pname = "zed";
  version = "0.30.2";

  src = fetchFromGitHub {
    owner = "authzed";
    repo = "zed";
    tag = "v${version}";
    hash = "sha256-ftSgp0zxUmSTJ7lFHxFdebKrCKbsRocDkfabVpyQ5Kg=";
  };

  vendorHash = "sha256-2AkknaufRhv79c9WQtcW5oSwMptkR+FB+1/OJazyGSM=";

  ldflags = [ "-X 'github.com/jzelinskie/cobrautil/v2.Version=${src.tag}'" ];

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

  meta = with lib; {
    changelog = "https://github.com/authzed/zed/releases/tag/${src.tag}";
    description = "Command line for managing SpiceDB";
    mainProgram = "zed";
    longDescription = ''
      SpiceDB is an open-source permissions database inspired by
      Google Zanzibar. zed is the command line client for SpiceDB.
    '';
    homepage = "https://authzed.com/";
    license = licenses.asl20;
    maintainers = with maintainers; [
      squat
      thoughtpolice
    ];
  };
}

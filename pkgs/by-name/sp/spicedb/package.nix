{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule (finalAttrs: {
  pname = "spicedb";
  version = "1.53.0";

  src = fetchFromGitHub {
    owner = "authzed";
    repo = "spicedb";
    tag = "v${finalAttrs.version}";
    hash = "sha256-kmhLvHPqHqSFkfUx9pr52Vvz+YgCPwknHqSY4zpVPtI=";
  };

  vendorHash = "sha256-G3isae85B6Js6H7XFAJ+v00caBV4+PO9IPCpHXzkBOs=";

  ldflags = [
    "-X 'github.com/jzelinskie/cobrautil/v2.Version=${finalAttrs.src.tag}'"
  ];

  subPackages = [ "cmd/spicedb" ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd spicedb \
      --bash <($out/bin/spicedb completion bash) \
      --fish <($out/bin/spicedb completion fish) \
      --zsh <($out/bin/spicedb completion zsh)
  '';

  meta = {
    changelog = "https://github.com/authzed/spicedb/releases/tag/${finalAttrs.src.tag}";
    description = "Open source permission database";
    longDescription = ''
      SpiceDB is an open-source permissions database inspired by
      Google Zanzibar.
    '';
    homepage = "https://authzed.com/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      squat
      thoughtpolice
    ];
    mainProgram = "spicedb";
  };
})

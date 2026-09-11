{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule (finalAttrs: {
  pname = "spicedb";
  version = "1.56.1";

  src = fetchFromGitHub {
    owner = "authzed";
    repo = "spicedb";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ak8AbbVMKzIWRJHezzpxF8vn2L0gu8069ghqf+/xYA4=";
  };

  vendorHash = "sha256-HOtYcs7F4Pf0yFyfuJOpROoFTTN630t+5lKoBLoJedM=";

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

{
  buildGoModule,
  fetchFromGitHub,
  lib,
  stdenv,
  installShellFiles,
  testers,
  callPackage,
}:

buildGoModule (finalAttrs: {
  pname = "cue";
  version = "0.14.1";

  src = fetchFromGitHub {
    owner = "cue-lang";
    repo = "cue";
    tag = "v${finalAttrs.version}";
    hash = "sha256-U/Cptda+2UIDIxuStNYAwZABlNdkS723TnoixVlvS4k=";
  };

  vendorHash = "sha256-hV5LO9R854YuazzS6VkxoY64h3+JboBgEDRWAoWats8=";

  subPackages = [ "cmd/*" ];

  nativeBuildInputs = [ installShellFiles ];

  ldflags = [
    "-s"
    "-w"
    "-X cuelang.org/go/cmd/cue/cmd.version=v${finalAttrs.version}"
  ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd cue \
      --bash <($out/bin/cue completion bash) \
      --fish <($out/bin/cue completion fish) \
      --zsh <($out/bin/cue completion zsh)
  '';

  passthru = {
    writeCueValidator = callPackage ./validator.nix { };
    tests = {
      test-001-all-good = callPackage ./tests/001-all-good.nix { };
      version = testers.testVersion {
        package = finalAttrs.finalPackage;
        command = "cue version";
        version = "v${finalAttrs.version}";
      };
    };
  };

  meta = {
    description = "Data constraint language which aims to simplify tasks involving defining and using data";
    homepage = "https://cuelang.org/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ aaronjheng ];
    mainProgram = "cue";
  };
})

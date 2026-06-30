{
  buildGoModule,
  fetchFromGitHub,
  lib,
  stdenv,
  installShellFiles,
  testers,
  tests,
  callPackage,
  pkgs,
}:

buildGoModule (finalAttrs: {
  pname = "cue";
  version = "0.17.0";

  src = fetchFromGitHub {
    owner = "cue-lang";
    repo = "cue";
    tag = "v${finalAttrs.version}";
    hash = "sha256-+mfGN2IX83JMwLsduBfj2h7Eeve6mmLpmXGFRxz/UfI=";
  };

  vendorHash = "sha256-dTUg6EnU6xKCGve9ksxqBF3BaoBdVlXFU8pTyZtV+RA=";

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

  passthru =
    let
      cue = finalAttrs.finalPackage;
      writeCueValidator = callPackage ./validator.nix { inherit cue; };
    in
    {
      inherit writeCueValidator;

      tests = {
        validation = tests.cue-validation.override {
          pkgs = pkgs.extend (_: _: { inherit writeCueValidator; });
        };

        test-001-all-good = callPackage ./tests/001-all-good.nix { inherit cue; };
        version = testers.testVersion {
          package = cue;
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

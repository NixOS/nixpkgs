{
  buildGoModule,
  fetchFromGitHub,
  lib,
  stdenv,
  installShellFiles,
  testers,
  cue,
  callPackage,
}:

buildGoModule rec {
  pname = "cue";
  version = "0.11.1";

  src = fetchFromGitHub {
    owner = "cue-lang";
    repo = "cue";
    rev = "v${version}";
    hash = "sha256-CLWPRVrfFQUwoLbZttetuq1T/Gb7vVEcrD7dxMzfgjA=";
  };

  vendorHash = "sha256-jl8TR1kxame30l7DkfOEioWA9wK/ACTNofiTi++vjuI=";

  subPackages = [ "cmd/*" ];

  nativeBuildInputs = [ installShellFiles ];

  ldflags = [
    "-s"
    "-w"
    "-X cuelang.org/go/cmd/cue/cmd.version=v${version}"
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
        package = cue;
        command = "cue version";
        version = "v${version}";
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
}

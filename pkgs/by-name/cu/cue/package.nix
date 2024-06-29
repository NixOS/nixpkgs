{ buildGoModule
, fetchFromGitHub
, lib
, installShellFiles
, testers
, cue
, callPackage
}:

buildGoModule rec {
  pname = "cue";
  version = "0.9.2";

  src = fetchFromGitHub {
    owner = "cue-lang";
    repo = "cue";
    rev = "v${version}";
    hash = "sha256-C3BvI43oo71y19ZRflqhKRQF7DwBBOV0yRlutv+W18g=";
  };

  vendorHash = "sha256-FsFignBh669E60S8l8siQHLzeSfB5X/XOHBXPMDX3Cg=";

  subPackages = [ "cmd/*" ];

  nativeBuildInputs = [ installShellFiles ];

  ldflags = [
    "-s"
    "-w"
    "-X cuelang.org/go/cmd/cue/cmd.version=v${version}"
  ];

  postInstall = ''
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

  meta = with lib;  {
    description = "Data constraint language which aims to simplify tasks involving defining and using data";
    homepage = "https://cuelang.org/";
    license = licenses.asl20;
    maintainers = with maintainers; [ aaronjheng ];
    mainProgram = "cue";
  };
}

{
  buildGoModule,
  fetchFromGitHub,
  lib,
  stdenv,
  installShellFiles,
  testers,
  callPackage,
  git,
}:

buildGoModule (finalAttrs: {
  pname = "cue";
  version = "0.16.0";

  src = fetchFromGitHub {
    owner = "cue-lang";
    repo = "cue";
    tag = "v${finalAttrs.version}";
    hash = "sha256-rBs2jd3lIzPV/f+xKs0SKxDBHPt0BypPvTU/ZXUc1S8=";
    leaveDotGit = true;
  };

  vendorHash = "sha256-KPhwu4Z8PcXr74NEZ9+Uz7FHIMzcKqkd20FDFW+a2NA=";

  subPackages = [ "cmd/*" ];

  nativeBuildInputs = [
    installShellFiles
    git
  ];

  preBuild = ''
    # fetchgit with leaveDotGit sanitizes .git/index; restore it so Go does not see a dirty tree.
    git reset --hard HEAD
    echo "/vendor/" >> .git/info/exclude
    git tag -f v${finalAttrs.version}
  '';

  ldflags = [
    "-s"
    "-w"
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
        version = "cue version v${finalAttrs.version}";
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

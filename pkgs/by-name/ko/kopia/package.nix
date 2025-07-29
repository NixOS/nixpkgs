{
  lib,
  buildGoModule,
  fetchFromGitHub,
  gitUpdater,
  installShellFiles,
  stdenv,
  testers,
  kopia,
}:

buildGoModule rec {
  pname = "kopia";
  version = "0.20.1";

  src = fetchFromGitHub {
    owner = "kopia";
    repo = "kopia";
    tag = "v${version}";
    hash = "sha256-hKtrHv7MQjA/AQ/frjP2tPT6zqVPPGnBxYuhWtUgIl0=";
  };

  vendorHash = "sha256-npNSNlS8gvbxtB4KeaiSsCUzxwJ0kwvnzDda/CZRVmM=";

  subPackages = [ "." ];

  ldflags = [
    "-X github.com/kopia/kopia/repo.BuildVersion=${version}"
    "-X github.com/kopia/kopia/repo.BuildInfo=${src.rev}"
  ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd kopia \
      --bash <($out/bin/kopia --completion-script-bash) \
      --zsh <($out/bin/kopia --completion-script-zsh)
  '';

  passthru = {
    updateScript = gitUpdater { rev-prefix = "v"; };
    tests = {
      kopia-version = testers.testVersion {
        package = kopia;
      };
    };
  };

  meta = with lib; {
    homepage = "https://kopia.io";
    description = "Cross-platform backup tool with fast, incremental backups, client-side end-to-end encryption, compression and data deduplication";
    mainProgram = "kopia";
    license = licenses.asl20;
    maintainers = [ maintainers.bbigras ];
  };
}

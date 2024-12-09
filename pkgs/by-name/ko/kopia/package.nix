{ lib, buildGoModule, fetchFromGitHub, gitUpdater, installShellFiles, stdenv, testers, kopia }:

buildGoModule rec {
  pname = "kopia";
  version = "0.18.2";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    hash = "sha256-7gQlBLmHvqsXXmSYllfsDJRx9VjW0AH7bXf6cG6lGOI=";
  };

  vendorHash = "sha256-lCUEL7rtnv8/86ZTHM4HsYplDnWj1xsFh83JKW6qRrk=";

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

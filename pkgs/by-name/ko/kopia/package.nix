{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  installShellFiles,
  stdenv,
  testers,
  kopia,
}:

buildGoModule rec {
  pname = "kopia";
  version = "0.21.1";

  src = fetchFromGitHub {
    owner = "kopia";
    repo = "kopia";
    tag = "v${version}";
    hash = "sha256-0i8bKah3a7MrgzATysgFCsmDZxK9qH+4hmBMW+GR9/4=";
  };

  vendorHash = "sha256-x5WIwYvQtbR72jqdD+O4Wg+4/qs24aqNeBuron/0ztk=";

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
    updateScript = nix-update-script { };
    tests = {
      kopia-version = testers.testVersion {
        package = kopia;
      };
    };
  };

  meta = {
    homepage = "https://kopia.io";
    changelog = "https://github.com/kopia/kopia/releases/tag/v${version}";
    description = "Cross-platform backup tool with fast, incremental backups, client-side end-to-end encryption, compression and data deduplication";
    mainProgram = "kopia";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      bbigras
      blenderfreaky
      nadir-ishiguro
    ];
  };
}

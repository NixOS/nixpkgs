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
  version = "0.22.2";

  src = fetchFromGitHub {
    owner = "kopia";
    repo = "kopia";
    tag = "v${version}";
    hash = "sha256-UtyOMXX6Q0fhlnSMmI5d+0BHGvoWkPZbcm9B6vWG05Y=";
  };

  vendorHash = "sha256-zjUkVU9I+Dp21QcOZPT30Ki570vQJPyK4UYSy8PEiZI=";

  subPackages = [ "." ];

  ldflags = [
    "-X github.com/kopia/kopia/repo.BuildVersion=${version}"
    "-X github.com/kopia/kopia/repo.BuildInfo=${src.rev}"
  ];

  nativeBuildInputs = [ installShellFiles ];

  postPatch = ''
    substituteInPlace internal/mount/mount_posix_webdav_helper_linux.go \
      --replace-fail "/usr/bin/mount" "mount" \
      --replace-fail "/usr/bin/umount" "umount"
  '';

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

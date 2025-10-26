{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  writableTmpDirAsHomeHook,
  pkg-config,
  btrfs-progs,
  gpgme,
  nix-update-script,
}:

buildGoModule rec {
  pname = "kraftkit";
  version = "0.12.5";

  src = fetchFromGitHub {
    owner = "unikraft";
    repo = "kraftkit";
    rev = "v${version}";
    hash = "sha256-/ReHXxvn/6dDJVxk5BOvxSZrlkDkZEfr+qM5raf2a3A=";
  };

  nativeBuildInputs = [
    pkg-config
    installShellFiles
    writableTmpDirAsHomeHook
  ];

  buildInputs = [
    gpgme
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    btrfs-progs
  ];

  vendorHash = "sha256-1rdpyOJVeyzYT0WHJbeqO3aH15FN1/9iQ9bEsjWwn4c=";

  ldflags = [
    "-s"
    "-w"
    "-X kraftkit.sh/internal/version.version=${version}"
  ];

  subPackages = [
    "cmd/kraft"
  ]
  ++ lib.optionals (stdenv.buildPlatform.canExecute stdenv.hostPlatform) [ "tools/genman" ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    $out/bin/genman generate ./docs/man/
    rm $out/bin/genman
    installManPage ./docs/man/*

    installShellCompletion --cmd kraft \
      --bash <($out/bin/kraft completion bash) \
      --fish <($out/bin/kraft completion fish) \
      --zsh <($out/bin/kraft completion zsh)
  '';

  passthru = {
    updateScript = nix-update-script {
      extraArgs = [
        "--version-regex"
        "^v([0-9.]+)"
      ];
    };
  };

  meta = {
    description = "Build and use highly customized and ultra-lightweight unikernel VMs";
    homepage = "https://github.com/unikraft/kraftkit";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [
      dit7ya
      cloudripper
    ];
    mainProgram = "kraft";
  };
}

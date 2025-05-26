{
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  kclvm_cli,
  kclvm,
  lib,
  nix-update-script,
  stdenv,
}:

buildGoModule rec {
  pname = "kcl";
  version = "0.11.2";

  src = fetchFromGitHub {
    owner = "kcl-lang";
    repo = "cli";
    rev = "v${version}";
    hash = "sha256-9QPGQ8PfXtb37RIrfqLeezobmXSpgvYzxJOWldmgnyc=";
  };

  vendorHash = "sha256-zToyM20ykPAd+EHwSUsX+4BvBPT8iXk5suGK2ZYBjvc=";

  subPackages = [ "cmd/kcl" ];

  ldflags = [
    "-w -s"
    "-X=kcl-lang.io/cli/pkg/version.version=v${version}"
  ];

  nativeBuildInputs = [
    installShellFiles
  ];

  buildInputs = [
    kclvm
    kclvm_cli
  ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    export HOME=$(mktemp -d)
    for shell in bash fish zsh; do
      installShellCompletion --cmd kcl \
        --$shell <($out/bin/kcl completion $shell)
    done
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck
    set -o pipefail
    $out/bin/kcl --version | grep $version
    $out/bin/kcl <(echo 'hello = "KCL"') | grep "hello: KCL"
    runHook postInstallCheck
  '';

  # By default, libs and bins are stripped. KCL will crash on darwin if they are.
  dontStrip = stdenv.hostPlatform.isDarwin;

  doCheck = true;

  updateScript = nix-update-script { };

  meta = {
    description = "A command line interface for KCL programming language";
    changelog = "https://github.com/kcl-lang/cli/releases/tag/v${version}";
    homepage = "https://github.com/kcl-lang/cli";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    maintainers = with lib.maintainers; [
      peefy
      selfuryon
    ];
    mainProgram = "kcl";
    broken = stdenv.buildPlatform != stdenv.hostPlatform;
  };
}

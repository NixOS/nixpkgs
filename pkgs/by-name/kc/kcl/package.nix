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

buildGoModule (finalAttrs: {
  pname = "kcl";
  version = "0.12.3";

  src = fetchFromGitHub {
    owner = "kcl-lang";
    repo = "cli";
    rev = "v${finalAttrs.version}";
    hash = "sha256-vOdL+It8wY+U0Jt68KPAxMe3th0muaCXlEkuEphCVVY=";
  };

  vendorHash = "sha256-NfRVgGtm8w/K0utb3/AlBfT71txpmJlOaFrdqGC8Dkg=";

  subPackages = [ "cmd/kcl" ];

  ldflags = [
    "-w -s"
    "-X=kcl-lang.io/cli/pkg/version.version=v${finalAttrs.version}"
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
    description = "Command line interface for KCL programming language";
    changelog = "https://github.com/kcl-lang/cli/releases/tag/v${finalAttrs.version}";
    homepage = "https://github.com/kcl-lang/cli";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    maintainers = with lib.maintainers; [
      selfuryon
    ];
    mainProgram = "kcl";
    broken = stdenv.buildPlatform != stdenv.hostPlatform;
  };
})

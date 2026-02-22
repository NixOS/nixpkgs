{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  versionCheckHook,
  writableTmpDirAsHomeHook,
}:

buildGoModule (finalAttrs: {
  pname = "ddev";
  version = "1.25.0";

  src = fetchFromGitHub {
    owner = "ddev";
    repo = "ddev";
    rev = "v${finalAttrs.version}";
    hash = "sha256-vRhFj2/lV34sDIDUxi2/zF9VJimhi6By6TQndl0O/Xg=";
  };

  nativeBuildInputs = [
    installShellFiles
  ];

  vendorHash = null;

  ldflags = [
    "-extldflags -static"
    "-X github.com/ddev/ddev/pkg/versionconstants.DdevVersion=v${finalAttrs.version}"
    "-X github.com/ddev/ddev/pkg/versionconstants.SegmentKey=v${finalAttrs.version}"
  ];

  # Tests need docker.
  doCheck = false;

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    # DDEV will try to create $HOME/.ddev, so we set $HOME to a temporary
    # directory.
    export HOME=$(mktemp -d)
    $out/bin/ddev_gen_autocomplete
    installShellCompletion --cmd ddev \
      --bash .gotmp/bin/completions/ddev_bash_completion.sh \
      --fish .gotmp/bin/completions/ddev_fish_completion.sh \
      --zsh .gotmp/bin/completions/ddev_zsh_completion.sh
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [
    versionCheckHook
    writableTmpDirAsHomeHook
  ];
  versionCheckKeepEnvironment = [ "HOME" ];

  meta = {
    description = "Docker-based local PHP+Node.js web development environments";
    homepage = "https://ddev.com/";
    license = lib.licenses.asl20;
    platforms = lib.platforms.unix;
    mainProgram = "ddev";
    maintainers = with lib.maintainers; [ remyvv ];
  };
})

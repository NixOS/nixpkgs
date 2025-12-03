{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  versionCheckHook,
  writableTmpDirAsHomeHook,
}:

buildGoModule rec {
  pname = "ddev";
  version = "1.24.10";

  src = fetchFromGitHub {
    owner = "ddev";
    repo = "ddev";
    rev = "v${version}";
    hash = "sha256-ijYkTVVuNLsG8+L4g1sWAJCSh/3MaoeirItLjcIg150=";
  };

  nativeBuildInputs = [
    installShellFiles
  ];

  vendorHash = null;

  ldflags = [
    "-extldflags -static"
    "-X github.com/ddev/ddev/pkg/versionconstants.DdevVersion=v${version}"
    "-X github.com/ddev/ddev/pkg/versionconstants.SegmentKey=v${version}"
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
  versionCheckProgramArg = "--version";
  versionCheckKeepEnvironment = [ "HOME" ];

  meta = with lib; {
    description = "Docker-based local PHP+Node.js web development environments";
    homepage = "https://ddev.com/";
    license = licenses.asl20;
    platforms = platforms.unix;
    mainProgram = "ddev";
    maintainers = with maintainers; [ remyvv ];
  };
}

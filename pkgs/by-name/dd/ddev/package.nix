{
  lib,
  stdenv,
  buildGoModule,
  docker-buildx,
  fetchFromGitHub,
  installShellFiles,
  makeBinaryWrapper,
  versionCheckHook,
  writableTmpDirAsHomeHook,
}:

let
  dockerCliPlugins = [
    docker-buildx
  ];
  dockerCliPluginsDirs = lib.strings.concatStringsSep ":" (
    map (p: "${p}/libexec/docker/cli-plugins") dockerCliPlugins
  );
in
buildGoModule (finalAttrs: {
  pname = "ddev";
  version = "1.25.1";

  src = fetchFromGitHub {
    owner = "ddev";
    repo = "ddev";
    rev = "v${finalAttrs.version}";
    hash = "sha256-kHGGUFX/xlmQsYxKPxSuRJHk2na9gU1Kd2jhNclAp5s=";
  };

  postPatch = ''
    (cd vendor/github.com/docker/cli && patch ${./cli-system-plugin-dir-from-env.patch})
  '';

  nativeBuildInputs = [
    makeBinaryWrapper
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

  postInstall = ''
    # make buildx available, it is a docker plugin which docker-compose uses and thus DDEV requires
    # https://github.com/NixOS/nixpkgs/blob/43fc054052db6ca5df042dcbe823740aa6c9a7c2/pkgs/applications/virtualization/docker/default.nix#L339
    wrapProgram $out/bin/ddev \
      --prefix DOCKER_CLI_PLUGIN_DIRS : "${dockerCliPluginsDirs}"
  ''
  + lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
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

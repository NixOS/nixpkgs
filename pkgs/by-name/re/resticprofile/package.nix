{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule rec {
  pname = "resticprofile";
  version = "0.26.0";

  src = fetchFromGitHub {
    owner = "creativeprojects";
    repo = "resticprofile";
    rev = "v${version}";
    hash = "sha256-y2rBUivs5yxlD/0uFwXW/Zc+o3foTmydwtEkyiuJwyw=";
  };

  vendorHash = "sha256-Qi7uhMXaWqI4NmYi+XTR15SyiUGhRiXPZmVud6aTM4s=";

  ldflags = [
    "-X main.commit=${src.rev}"
    "-X main.date=unknown"
    "-X main.builtBy=nixpkgs"
  ];

  nativeBuildInputs = [ installShellFiles ];

  preCheck = ''
    rm battery_test.go # tries to get battery data
    rm update_test.go # tries to use network
    rm lock/lock_test.go # needs ping
    rm preventsleep/caffeinate_test.go # tries to communicate with dbus
    rm priority/ioprio_test.go # tries to set nice(2) IO priority
    rm restic/downloader_test.go # tries to use network
    rm schedule/schedule_test.go # tries to use systemctl

    # `config/path_test.go` expects `$HOME` to be the same as `~nixbld` which is `$NIX_BUILD_TOP`
    export HOME="$NIX_BUILD_TOP"
    # `util/tempdir_test.go` expects `$HOME/.cache` to exist
    mkdir "$HOME/.cache"
  '';

  installPhase = ''
    runHook preInstall

    install -Dm755 $GOPATH/bin/resticprofile -t $out/bin

    installShellCompletion --cmd resticprofile \
        --bash <($out/bin/resticprofile generate --bash-completion) \
        --zsh <($out/bin/resticprofile generate --zsh-completion)

    runHook postInstall
  '';

  meta = {
    changelog = "https://github.com/creativeprojects/resticprofile/releases/tag/${src.rev}";
    description = "Configuration profiles manager for restic backup";
    homepage = "https://creativeprojects.github.io/resticprofile/";
    license = with lib.licenses; [
      gpl3Only
      lgpl3 # bash shell completion
    ];
    mainProgram = "resticprofile";
    maintainers = with lib.maintainers; [ tomasajt ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
}

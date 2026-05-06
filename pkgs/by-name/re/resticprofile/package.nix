{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  restic,
  bash,
  testers,
  resticprofile,
}:

buildGoModule (finalAttrs: {
  pname = "resticprofile";
  version = "0.33.0";

  src = fetchFromGitHub {
    owner = "creativeprojects";
    repo = "resticprofile";
    tag = "v${finalAttrs.version}";
    hash = "sha256-VkE8xZiHRXTPikDA60vV6frTbokwcPtNryQdEKdngwI=";
  };

  postPatch = ''
    substituteInPlace shell/command.go \
        --replace-fail '"bash"' '"${lib.getExe bash}"'

    substituteInPlace filesearch/filesearch.go \
        --replace-fail 'paths := getSearchBinaryLocations()' 'return "${lib.getExe restic}", nil; paths := getSearchBinaryLocations()'

  '';

  vendorHash = "sha256-Dp/uRr4ARdiKSXZziQNnbJm+vsR2gYy0QmubwiIEMvM=";

  ldflags = [
    "-X main.version=${finalAttrs.version}"
    "-X main.commit=${finalAttrs.src.rev}"
    "-X main.date=unknown"
    "-X main.builtBy=nixpkgs"
  ];

  nativeBuildInputs = [ installShellFiles ];

  preCheck = ''
    rm batt/battery_test.go # tries to get battery data
    rm commands_test.go # tries to use systemctl
    rm config/path_test.go # expects normal environment
    rm lock/lock_test.go # needs ping
    rm preventsleep/caffeinate_test.go # tries to communicate with dbus
    rm priority/ioprio_test.go # tries to set nice(2) IO priority
    rm restic/downloader_test.go # tries to use network
    rm schedule/*_test.go # tries to use systemctl
    rm update_test.go # tries to use network
    rm user/user_test.go # expects normal environment
    rm util/tempdir_test.go # expects normal environment
  '';

  checkFlags =
    let
      skippedTests = [
        # mount: fusermount: exec: "fusermount": executable file not found in $PATH
        "TestMemFS"
      ];
    in
    [ "-skip=^${builtins.concatStringsSep "$|^" skippedTests}$" ];

  installPhase = ''
    runHook preInstall

    install -Dm755 $GOPATH/bin/resticprofile -t $out/bin

    installShellCompletion --cmd resticprofile \
        --bash <($out/bin/resticprofile generate --bash-completion) \
        --zsh <($out/bin/resticprofile generate --zsh-completion)

    runHook postInstall
  '';

  passthru = {
    tests.version = testers.testVersion {
      package = resticprofile;
      command = "resticprofile version";
    };
  };

  meta = {
    changelog = "https://github.com/creativeprojects/resticprofile/releases/tag/v${finalAttrs.version}";
    description = "Configuration profiles manager for restic backup";
    homepage = "https://creativeprojects.github.io/resticprofile/";
    license = with lib.licenses; [
      gpl3Only
      lgpl3 # bash shell completion
    ];
    mainProgram = "resticprofile";
    maintainers = with lib.maintainers; [
      tomasajt
      bbigras
    ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})

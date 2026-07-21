{
  stdenv,
  buildNpmPackage,
  fetchFromGitHub,
  lib,
  nix-update-script,
  gitlab-ci-local,
  testers,
  makeBinaryWrapper,
  rsync,
  gitMinimal,
}:

buildNpmPackage rec {
  pname = "gitlab-ci-local";
  version = "4.64.1";

  src = fetchFromGitHub {
    owner = "firecow";
    repo = "gitlab-ci-local";
    rev = version;
    hash = "sha256-scZ6KqpO/E3Ycu6Nn5o/4LaEpSAOWim8mOqpByjZlZE=";
  };

  npmDepsHash = "sha256-IoycsUU+7o4A3d+pGQvyBvaIqg7fdvwS8Pay9MmRqM4=";

  nativeBuildInputs = [
    makeBinaryWrapper
  ];

  postPatch = ''
    # remove cleanup which runs git commands
    substituteInPlace package.json \
      --replace-fail "npm run cleanup" "true"

    # set a script name to avoid yargs using index.js as $0
    substituteInPlace src/handler.ts src/index.ts \
      --replace-fail 'yargs(process.argv.slice(2))' 'yargs(process.argv.slice(2)).scriptName("gitlab-ci-local")'
  '';

  postInstall = ''
    wrapProgram $out/bin/gitlab-ci-local \
      --prefix PATH : "${
        lib.makeBinPath [
          rsync
          gitMinimal
        ]
      }"
  ''
  + lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd gitlab-ci-local \
      --bash <(SHELL=bash $out/bin/gitlab-ci-local --completion) \
      --zsh <(SHELL=zsh $out/bin/gitlab-ci-local --completion)
  '';

  passthru = {
    updateScript = nix-update-script { };
    tests.version = testers.testVersion {
      package = gitlab-ci-local;
    };
  };

  meta = {
    description = "Run gitlab pipelines locally as shell executor or docker executor";
    mainProgram = "gitlab-ci-local";
    longDescription = ''
      Tired of pushing to test your .gitlab-ci.yml?
      Run gitlab pipelines locally as shell executor or docker executor.
      Get rid of all those dev specific shell scripts and make files.
    '';
    homepage = "https://github.com/firecow/gitlab-ci-local";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pineapplehunter ];
    platforms = lib.platforms.all;
  };
}

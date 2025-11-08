{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchYarnDeps,
  yarnConfigHook,
  yarnBuildHook,
  yarnInstallHook,
  nodejs,
  nix-update-script,
  runCommand,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "prettierd";
  version = "0.26.2";

  src = fetchFromGitHub {
    owner = "fsouza";
    repo = "prettierd";
    tag = "v${finalAttrs.version}";
    hash = "sha256-KvFOvWQZBppvHbvUvGQu39j8aV/pQFwfuqjFQqdb7lI=";
  };

  offlineCache = fetchYarnDeps {
    yarnLock = finalAttrs.src + "/yarn.lock";
    hash = "sha256-Rf7km2WUODqWu8U8iiHNrb5dMamIm1XCsRnldO71j5A=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    yarnConfigHook
    yarnBuildHook
    yarnInstallHook
    nodejs
  ];

  # launch the daemon with the same node version used to run the CLI
  # fixes "Error: spawn node ENOENT" if node isn't available on the user's path
  postInstall = ''
    wrapProgram $out/bin/prettierd \
      --prefix PATH : ${lib.makeBinPath [ nodejs ]}
  '';

  passthru = {
    updateScript = nix-update-script { };

    tests = lib.optionalAttrs (!stdenv.hostPlatform.isDarwin) {
      format =
        runCommand "prettierd-format-file-test" { nativeBuildInputs = [ finalAttrs.finalPackage ]; }
          ''
            export HOME=$(mktemp -d)
            prettierd ${finalAttrs.src}/package.json < ${finalAttrs.src}/package.json > $out
          '';
    };
  };

  meta = {
    mainProgram = "prettierd";
    description = "Prettier, as a daemon, for improved formatting speed";
    homepage = "https://github.com/fsouza/prettierd";
    license = lib.licenses.isc;
    changelog = "https://github.com/fsouza/prettierd/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    platforms = with lib.platforms; linux ++ darwin;
    maintainers = with lib.maintainers; [
      NotAShelf
      n3oney
    ];
  };
})

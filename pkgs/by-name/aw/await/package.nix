{
  lib,
  stdenv,
  fetchFromGitHub,
  installShellFiles,
  versionCheckHook,
}:

stdenv.mkDerivation rec {
  pname = "await";
  version = "2.3.0";

  src = fetchFromGitHub {
    owner = "slavaGanzin";
    repo = "await";
    tag = version;
    hash = "sha256-UfEjcf8NuLRzu/57aS738Do/lXzYX5lrus1xgZ7dask=";
  };

  nativeBuildInputs = [ installShellFiles ];

  buildPhase = ''
    runHook preBuild
    $CC await.c -o await -l pthread
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -Dm755 await -t $out/bin
    install -Dm444 LICENSE -t $out/share/licenses/await
    install -Dm444 README.md -t $out/share/doc/await
    installShellCompletion --cmd await autocompletions/await.{bash,fish,zsh}

    runHook postInstall
  '';

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;
  versionCheckProgramArg = "--version";

  meta = {
    changelog = "https://github.com/slavaGanzin/await/releases/tag/${version}";
    description = "Small binary that runs a list of commands in parallel and awaits termination";
    homepage = "https://github.com/slavaGanzin/await";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ chewblacka ];
    platforms = lib.platforms.all;
    mainProgram = "await";
  };
}

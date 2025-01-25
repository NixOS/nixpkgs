{
  lib,
  stdenv,
  fetchFromGitHub,
  installShellFiles,
  versionCheckHook,
}:

stdenv.mkDerivation rec {
  pname = "await";
  version = "1.0.7";

  src = fetchFromGitHub {
    owner = "slavaGanzin";
    repo = "await";
    rev = version;
    hash = "sha256-Yrit1WdWIfjwqbjvyjrPT3EqSSkooYX+uoOstbxy//I=";
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
  versionCheckProgramArg = [ "--version" ];

  meta = with lib; {
    description = "Small binary that runs a list of commands in parallel and awaits termination";
    homepage = "https://await-cli.app";
    license = licenses.mit;
    maintainers = with maintainers; [ chewblacka ];
    platforms = platforms.all;
    mainProgram = "await";
  };
}

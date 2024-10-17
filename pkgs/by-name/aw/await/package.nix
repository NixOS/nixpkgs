{
  lib,
  stdenv,
  fetchFromGitHub,
  installShellFiles,
}:

stdenv.mkDerivation rec {
  pname = "await";
  version = "1.0.5";

  src = fetchFromGitHub {
    owner = "slavaGanzin";
    repo = "await";
    rev = "v${version}";
    hash = "sha256-0U9eLQDvHnRUJt46AI4bDWZfGynqjaWs9teidWP3RsA=";
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

  meta = with lib; {
    description = "Small binary that runs a list of commands in parallel and awaits termination";
    homepage = "https://await-cli.app";
    license = licenses.mit;
    maintainers = with maintainers; [ chewblacka ];
    platforms = platforms.all;
    mainProgram = "await";
  };
}

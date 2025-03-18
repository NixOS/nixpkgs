{
  lib,
  stdenv,
  fetchFromGitHub,
  installShellFiles,
}:

stdenv.mkDerivation rec {
  pname = "await";
  version = "1.0.2";

  src = fetchFromGitHub {
    owner = "slavaGanzin";
    repo = "await";
    rev = "v${version}";
    hash = "sha256-qvSRuRLZnUptXYknyRn4GgmYtj9BnI8flN6EhadbKMw=";
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
    installShellCompletion --cmd await autocomplete.{bash,fish,zsh}

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
